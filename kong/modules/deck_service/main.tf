# ============================================================================
# deck_service module
#
# Produces a list of Kong service objects (with nested routes and plugins)
# in the decK declarative format.  No resources are created — only data.
#
# NOTE: We use jsondecode(jsonencode(...)) throughout to normalize HCL
# structural types into dynamic values, avoiding Terraform's
# "inconsistent conditional result types" errors.
# ============================================================================

locals {
  supported_routes = flatten([
    for feature in var.supported_features : [
      for route in var.routes : route if route.feature == feature
    ]
  ])

  has_routes = length(local.supported_routes) > 0

  service_name = "${var.brand_id}.${var.component_prefix}-${var.service_name}"

  route_map = {
    for route in local.supported_routes :
    "${var.brand_id}.${var.component_prefix}-${replace(var.service_name, "/-v[0-9]+/", "")}_${route.method}-${route.name}" => route
  }

  # Headers to remove in response-transformer
  headers_to_remove = compact(concat(
    var.connector_measurements_header != "none" ? [var.connector_measurements_header] : [],
    var.consent_id_portability_header != "none" ? [var.consent_id_portability_header] : []
  ))

  # ---------------------------------------------------------------------------
  # Service-level plugins — built as a flat list using jsondecode/jsonencode
  # to avoid Terraform tuple type mismatches in conditionals.
  # ---------------------------------------------------------------------------
  service_plugins_raw = flatten([
    [
      {
        name      = "cors"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          origins = [var.cors_origins]
          methods = ["GET", "POST", "PUT", "DELETE", "PATCH"]
        }
      },
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
      {
        name      = "${var.component_prefix}-fapi-interaction-id"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          musthavefapiinteractionid = var.must_have_fapi_interaction_id
        }
      },
      {
        name      = "oob-kong-consumer-handler"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          sslcertificateheadername = var.ssl_certificate_header_name
        }
      }
    ],
    var.internal_api ? [] : [
      {
        name      = "${var.component_prefix}-error-handler"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {}
      }
    ],
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
  # Build routes with their per-route plugins.
  # Uses jsondecode(jsonencode(...)) to normalize dynamic types.
  # When route_map is empty, the for expression produces an empty list.
  # ---------------------------------------------------------------------------

  routes = [
    for route_key, route in local.route_map : {
      name       = route_key
      protocols  = ["http", "https"]
      paths      = var.route_base_path == "" ? [route.path] : ["${var.route_base_path}${replace(route.path, "/^(.?)//", "")}"]
      hosts      = [for h in var.public_fqdns : h if h != ""]
      methods    = [route.method, "OPTIONS"]
      strip_path = false
      plugins = jsondecode(jsonencode(flatten([
        # Token introspection
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
        # Request transformer
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
        # Response transformer
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
        # PCM api-event
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
        # MQD event
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
        # Route block
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
        # HTTP log
        var.log_request_response_enabled && route.must_log_request_response ? [
          {
            name      = "http-log"
            protocols = ["grpc", "grpcs", "http", "https"]
            config = {
              http_endpoint = var.log_request_response_collector_url_http
            }
          }
        ] : [],
        # Operational limits
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
  # API docs route (optional)
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
  # Final service object
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
