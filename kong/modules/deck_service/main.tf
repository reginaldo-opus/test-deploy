# ============================================================================
# deck_service module — Gerador de Service Kong no Formato Declarativo
#
# Este é o módulo core do projeto. Produz um service Kong completo
# com routes e plugins no formato declarativo do decK.
#
# NÃO cria recursos — apenas gera estruturas de dados (HCL maps).
#
# Hierarquia de plugins:
#   Service-level (aplicados a todas as rotas do service):
#     ├── cors                        — Sempre presente
#     ├── rate-limiting               — Limitação por IP/minuto
#     ├── oob-fapi-interaction-id     — Header FAPI obrigatório
#     ├── oob-kong-consumer-handler   — Consumer handler (certificado)
#     ├── oob-error-handler           — Padroniza erros (se não internal_api)
#     └── oob-ocsp-validator          — Validação OCSP (condicional)
#
#   Route-level (aplicados por rota, baseado em flags da rota):
#     ├── oob-token-introspection     — Se scopes definidos e api_security_enabled
#     ├── request-transformer         — Sempre (adiciona X-Brand-ID, Content-Type)
#     ├── response-transformer        — Sempre (remove headers internos, adiciona x-v)
#     ├── oob-api-event               — Se must_report_pcm = true
#     ├── oob-mqd-event               — Se mqd_event_enabled e must_report_mqd
#     ├── oob-route-block             — Se route_block_enabled e datas definidas
#     ├── http-log                    — Se log_request_response_enabled
#     └── oob-operational-limits      — Se operational_limits_enabled
#
# Padrão jsondecode(jsonencode(...)):
#   Usado extensivamente para normalizar tipos HCL dinâmicos.
#   Sem isso, Terraform rejeita condicionais que retornam tipos diferentes
#   (ex: lista vazia vs lista de objetos com campos distintos).
# ============================================================================

locals {
  # Filtra rotas: só inclui rotas cujo "feature" está em supported_features.
  # Isso permite que cada brand tenha features diferentes (ex: um brand
  # que não suporta "payments" não terá rotas de pagamento).
  supported_routes = flatten([
    for feature in var.supported_features : [
      for route in var.routes : route if route.feature == feature
    ]
  ])

  has_routes = length(local.supported_routes) > 0

  # Nome do service no Kong: "{brand_id}.{prefix}-{service_name}"
  # Ex: "brand1.oob-status", "brand2.oob-financial-data"
  service_name = "${var.brand_id}.${var.component_prefix}-${var.service_name}"

  # Mapa de rotas indexado por chave única.
  # A chave combina brand, service (sem versão) e método para ser legível.
  # Ex: "brand1.oob-status_GET-status-v2"
  route_map = {
    for route in local.supported_routes :
    "${var.brand_id}.${var.component_prefix}-${replace(var.service_name, "/-v[0-9]+/", "")}_${route.method}-${route.name}" => route
  }

  # Headers internos que devem ser removidos das respostas
  # (não devem vazar para o cliente externo)
  headers_to_remove = compact(concat(
    var.connector_measurements_header != "none" ? [var.connector_measurements_header] : [],
    var.consent_id_portability_header != "none" ? [var.consent_id_portability_header] : []
  ))

  # ---------------------------------------------------------------------------
  # Service-level plugins
  # ---------------------------------------------------------------------------
  service_plugins_raw = flatten([
    [
      # CORS: permite cross-origin requests dos FQDNs configurados
      {
        name      = "cors"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          origins = [var.cors_origins]
          methods = ["GET", "POST", "PUT", "DELETE", "PATCH"]
        }
      },
      # Rate limiting por IP: protege contra abuso individual
      {
        name      = "rate-limiting"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          minute              = var.transaction_limit_per_ip_per_minute
          limit_by            = "ip"
          policy              = "local"
          hide_client_headers = true
        }
      },
      # FAPI Interaction ID: valida/gera header x-fapi-interaction-id
      {
        name      = "${var.component_prefix}-fapi-interaction-id"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          musthavefapiinteractionid = var.must_have_fapi_interaction_id
        }
      },
      # Consumer handler: identifica o consumer pelo certificado mTLS
      {
        name      = "oob-kong-consumer-handler"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          sslcertificateheadername = var.ssl_certificate_header_name
        }
      }
    ],
    # Error handler: padroniza respostas de erro (só para APIs externas)
    var.internal_api ? [] : [
      {
        name      = "${var.component_prefix}-error-handler"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {}
      }
    ],
    # OCSP validator: validação de certificados via OCSP (condicional)
    var.ocsp_validation_enabled ? [
      {
        name      = "${var.component_prefix}-ocsp-validator"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          sslcertificateheadername          = var.ssl_certificate_header_name
          ocspcachemsduration               = var.ocsp_cache_ms_duration
          ocspserverrequestmstimeout        = var.ocsp_server_request_ms_timeout
          ocsppercertserverrequestmstimeout = var.ocsp_per_cert_server_request_ms_timeout
        }
      }
    ] : [],
  ])

  service_plugins = jsondecode(jsonencode(local.service_plugins_raw))

  # ---------------------------------------------------------------------------
  # Routes com plugins per-route
  #
  # Cada rota tem plugins condicionais baseados nos flags da definição.
  # Quando route_map está vazio, o for gera uma lista vazia (sem service).
  # ---------------------------------------------------------------------------

  routes = [
    for route_key, route in local.route_map : {
      name       = route_key
      protocols  = ["http", "https"]
      paths      = var.route_base_path == "" ? [route.path] : ["${var.route_base_path}${replace(route.path, "/^(.?)//", "")}"]
      hosts      = [for h in var.public_fqdns : h if h != ""]
      methods    = [route.method, "OPTIONS"]  # OPTIONS sempre incluído (CORS preflight)
      strip_path = false
      plugins = jsondecode(jsonencode(flatten([
        # Token introspection: valida OAuth2 token se scopes definidos
        length(flatten(route.scopes)) > 0 && var.api_security_enabled ? [
          {
            name      = "${var.component_prefix}-token-introspection"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              authserverurl      = var.auth_server_url
              authserverbasepath = var.auth_server_base_path
              clientid           = var.introspection_client_id
              clientsecret       = var.introspection_client_secret
              scopes             = route.scopes
              certificateheader  = var.ssl_certificate_header_name
              mustvalidatejws    = route.request_format == "JWT"
            }
          }
        ] : [],
        # Request transformer: manipula headers de entrada
        # - Remove X-Brand-ID (evita spoofing), re-adiciona com valor correto
        # - Ajusta Content-Type e Accept baseado no formato (JSON/JWT)
        [
          {
            name      = "request-transformer"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              remove = {
                headers = concat(
                  ["X-Brand-ID"],
                  route.response_format == "JWT" ? ["Accept"] : [],
                  route.method == "GET" ? ["Content-Type"] : []
                )
              }
              add = {
                headers = concat(
                  ["X-Brand-ID:${var.brand_id}"],
                  route.request_format == "JSON" ? ["Content-Type:application/json"] : [],
                  route.response_format == "JWT" ? ["Accept:application/jwt"] : []
                )
              }
            }
          }
        ],
        # Response transformer: manipula headers de saída
        # - Remove headers internos (connector measurements, consent portability)
        # - Adiciona x-v com versão da API
        [
          {
            name      = "response-transformer"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              remove = {
                headers = local.headers_to_remove
              }
              add = {
                headers = ["x-v:${route.api_version}"]
              }
            }
          }
        ],
        # PCM api-event: publica evento de API para métricas PCM
        route.must_report_pcm ? [
          {
            name      = "${var.component_prefix}-api-event"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              brandid                      = var.brand_id
              sslcertificateheadername     = var.ssl_certificate_header_name
              xforwardedforheadername      = var.x_forwarded_for_header_name
              xconnectormeasurementsheader = var.connector_measurements_header
              serverorgid                  = var.server_org_id
              pubsubid                     = var.pubsub_id
              xconsentidportabilityheader  = var.consent_id_portability_header
            }
          }
        ] : [],
        # MQD event: publica evento MQD (qualidade de dados)
        var.mqd_event_enabled && route.must_report_mqd ? [
          {
            name      = "${var.component_prefix}-mqd-event"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              sslcertificateheadername = var.ssl_certificate_header_name
              serverorgid              = var.server_org_id
              pubsubid                 = var.pubsub_id
              largeeventstatestorename = var.dapr_large_event_store
            }
          }
        ] : [],
        # Route block: bloqueia rota baseado em datas regulatórias
        # block_before_date = bloqueia ANTES dessa data
        # block_from_date = bloqueia A PARTIR dessa data
        var.route_block_enabled && (route.block_before_date != "none" || route.block_from_date != "none") ? [
          {
            name      = "${var.component_prefix}-route-block"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              blockbeforedate = route.block_before_date
              blockfromdate   = route.block_from_date
            }
          }
        ] : [],
        # HTTP log: envia request/response para coletor de logs
        var.log_request_response_enabled && route.must_log_request_response ? [
          {
            name      = "http-log"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              http_endpoint = var.log_request_response_collector_url_http
            }
          }
        ] : [],
        # Operational limits: limites operacionais por rota
        var.operational_limits_enabled && route.has_operational_limits ? [
          {
            name      = "${var.component_prefix}-operational-limits"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              brandid            = var.brand_id
              allowwhenoverlimit = var.operational_limits_allow_when_over_limit
              checklimittimeoutms = var.operational_limits_check_limit_timeout_ms
            }
          }
        ] : [],
      ])))
    }
  ]

  # ---------------------------------------------------------------------------
  # API docs route (opcional)
  # Rota especial que redireciona /api-docs para /v2/api-docs do backend
  # ---------------------------------------------------------------------------
  docs_routes = local.has_routes && var.api_docs_enabled && var.docs_route != "" ? [
    {
      name       = "${var.brand_id}.${var.component_prefix}-${var.service_name}_GET-api-docs"
      protocols  = ["http", "https"]
      paths      = [var.docs_route]
      methods    = ["GET"]
      strip_path = false
      plugins = [
        {
          name      = "request-transformer"
          protocols = ["grpc", "grpcs", "http", "https"]
          config = {
            replace = {
              uri = "/v2/api-docs"
            }
          }
        }
      ]
    }
  ] : []

  # ---------------------------------------------------------------------------
  # Service object final — combina service + plugins + routes
  #
  # Se não há rotas suportadas (has_routes = false), retorna lista vazia.
  # Isso acontece quando o brand não tem as features necessárias.
  # ---------------------------------------------------------------------------
  service_objects = local.has_routes ? jsondecode(jsonencode([
    {
      name     = local.service_name
      protocol = var.service_protocol
      host     = var.service_host
      port     = var.service_port
      plugins  = local.service_plugins
      routes   = jsondecode(jsonencode(concat(local.routes, local.docs_routes)))
    }
  ])) : jsondecode(jsonencode([]))
}

output "services" {
  value = local.service_objects
}
