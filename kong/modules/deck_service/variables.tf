# ============================================================================
# deck_service/variables.tf — Variáveis do Módulo Service
#
# Cada variável corresponde a uma configuração do service Kong ou
# a um flag que controla a inclusão condicional de plugins.
#
# Grupos:
#   - Identidade do service (brand_id, service_name, host, port)
#   - Segurança (auth, SSL, OCSP)
#   - Plugins condicionais (FAPI, route block, MQD, logs, limites)
#   - Rotas (lista de definições com scopes, métodos, flags)
# ============================================================================

# --- Identidade do Service ---

variable "brand_id" {
  description = "ID do brand/tenant (ex: 'brand1'). Usado como prefixo no nome do service."
  type = string
}

variable "component_prefix" {
  description = "Prefixo do componente (ex: 'oob'). Usado nos nomes de plugins customizados."
  type = string
}

variable "service_name" {
  description = "Nome do serviço (ex: 'status', 'financial-data'). Combinado com brand_id e prefix."
  type = string
}

variable "service_protocol" {
  description = "Protocolo upstream (http ou https). Auth server usa https."
  type    = string
  default = "http"
}

variable "service_host" {
  description = "Hostname do backend upstream (ex: 'oob-status', 'oob-payment')"
  type = string
}

variable "service_port" {
  description = "Porta do backend upstream (geralmente 8080)"
  type = number
}

variable "route_base_path" {
  description = "Prefixo de path para todas as rotas deste service (usado pelo auth-server)"
  type    = string
  default = ""
}

# --- Rede e CORS ---

variable "cors_origins" {
  description = "Origins permitidos para CORS"
  type = string
}

variable "transaction_limit_per_ip_per_minute" {
  description = "Limite de transações por IP por minuto"
  type = number
}

variable "public_fqdns" {
  description = "Lista de FQDNs públicos que ativam as rotas deste service"
  type = list(string)
}

variable "supported_features" {
  description = "Features habilitadas para este brand (filtra quais rotas são criadas)"
  type = list(string)
}

variable "internal_api" {
  description = "Se true, remove oob-error-handler (APIs internas não precisam de padronização de erro)"
  type    = bool
  default = false
}

# --- Segurança / Auth ---

variable "auth_server_url" {
  description = "URL do servidor de autenticação"
  type = string
}

variable "auth_server_base_path" {
  description = "Base path do servidor de autenticação"
  type    = string
  default = "/auth/"
}

variable "introspection_client_id" {
  description = "Client ID para token introspection no Auth Server"
  type = string
}

variable "introspection_client_secret" {
  description = "Client Secret para token introspection (valor sensível)"
  type      = string
  sensitive = true
}

variable "api_security_enabled" {
  description = "Se true, adiciona plugin oob-token-introspection nas rotas com scopes"
  type = bool
}

variable "ssl_certificate_header_name" {
  description = "Nome do header HTTP com o certificado do cliente (mTLS termination)"
  type = string
}

variable "x_forwarded_for_header_name" {
  description = "Nome do header com IP de origem (usado pelo plugin api-event)"
  type = string
}

# --- Plugins Condicionais ---

variable "must_have_fapi_interaction_id" {
  description = "Data (YYYY-MM-DD) a partir da qual x-fapi-interaction-id é obrigatório, ou 'never'"
  type = string
}

variable "connector_measurements_header" {
  description = "Nome do header de medições de conector (removido na resposta). 'none' = não usar."
  type    = string
  default = "X-OOB-Connector-Measurements"
}

variable "consent_id_portability_header" {
  description = "Nome do header de portabilidade de consentimento. 'none' = não usar."
  type    = string
  default = "none"
}

variable "route_block_enabled" {
  description = "Se true, adiciona oob-route-block nas rotas com datas regulatórias"
  type = bool
}

variable "mqd_event_enabled" {
  description = "Se true, adiciona oob-mqd-event nas rotas com must_report_mqd"
  type = bool
}

# --- OCSP ---

variable "ocsp_validation_enabled" {
  description = "Se true, adiciona oob-ocsp-validator no service"
  type = bool
}

variable "ocsp_cache_ms_duration" {
  description = "Duração do cache de OCSP (em ms)"
  type = number
}

variable "ocsp_server_request_ms_timeout" {
  description = "Timeout do servidor OCSP (em ms)"
  type = number
}

variable "ocsp_per_cert_server_request_ms_timeout" {
  description = "Timeout por certificado no servidor OCSP (em ms)"
  type = string
}

# --- Logs ---

variable "log_request_response_enabled" {
  description = "Se true, adiciona http-log nas rotas com must_log_request_response"
  type = bool
}

variable "log_request_response_collector_url_http" {
  description = "URL do coletor de logs"
  type = string
}

# --- Limites Operacionais ---

variable "operational_limits_enabled" {
  description = "Se true, adiciona oob-operational-limits nas rotas com has_operational_limits"
  type = bool
}

variable "operational_limits_allow_when_over_limit" {
  description = "Se true, permite que as rotas ultrapassem os limites"
  type = bool
}

variable "operational_limits_check_limit_timeout_ms" {
  description = "Timeout para checar limites (em ms)"
  type = number
}

# --- Identidade OOB ---

variable "server_org_id" {
  description = "ID da organização no diretório de participantes (usado pelo api-event)"
  type    = string
  default = ""
}

variable "pubsub_id" {
  description = "ID do pubsub (usado pelo api-event)"
  type    = string
  default = ""
}

variable "dapr_large_event_store" {
  description = "ID do store de eventos grandes (usado pelo api-event)"
  type    = string
  default = ""
}

variable "api_docs_enabled" {
  description = "Se true, cria rota especial /api-docs que redireciona para /v2/api-docs"
  type    = bool
  default = false
}

variable "docs_route" {
  description = "Rota para os docs"
  type    = string
  default = ""
}

variable "routes" {
  description = <<-EOT
    Lista de definições de rotas. Cada rota controla:
      - name: identificador da rota
      - method: HTTP method (GET, POST, PUT, DELETE, PATCH)
      - path: regex do path (prefixo ~)
      - scopes: escopos OAuth2 necessários (lista de listas = OR de ANDs)
      - must_report_pcm: se true, adiciona plugin api-event
      - must_report_mqd: se true, adiciona plugin mqd-event
      - must_log_request_response: se true, adiciona plugin http-log
      - request_format: "JWT", "JSON" ou "none"
      - response_format: "JWT" ou "JSON"
      - api_version: versão da API (adicionada no header x-v)
      - feature: feature necessária (core, payments, financial-data, etc.)
      - block_before_date: bloqueia rota ANTES desta data (YYYY-MM-DD ou "none")
      - block_from_date: bloqueia rota A PARTIR desta data
      - has_operational_limits: se true, adiciona plugin operational-limits
  EOT
  type = list(object({
    name                      = string
    method                    = string
    path                      = string
    scopes                    = list(list(string))
    must_report_pcm           = bool
    must_report_mqd           = bool
    must_log_request_response = bool
    request_format            = string
    response_format           = string
    api_version               = string
    feature                   = string
    block_before_date         = string
    block_from_date           = string
    has_operational_limits    = bool
  }))
  default = []
}
