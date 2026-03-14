variable "brand_id" {
  type = string
}

variable "component_prefix" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_protocol" {
  type    = string
  default = "http"
}

variable "service_host" {
  type = string
}

variable "service_port" {
  type = number
}

variable "route_base_path" {
  type    = string
  default = ""
}

variable "cors_origins" {
  type = string
}

variable "transaction_limit_per_ip_per_minute" {
  type = number
}

variable "public_fqdns" {
  type = list(string)
}

variable "supported_features" {
  type = list(string)
}

variable "internal_api" {
  type    = bool
  default = false
}

variable "auth_server_url" {
  type = string
}

variable "auth_server_base_path" {
  type    = string
  default = "/auth/"
}

variable "introspection_client_id" {
  type = string
}

variable "introspection_client_secret" {
  type      = string
  sensitive = true
}

variable "api_security_enabled" {
  type = bool
}

variable "ssl_certificate_header_name" {
  type = string
}

variable "x_forwarded_for_header_name" {
  type = string
}

variable "must_have_fapi_interaction_id" {
  type = string
}

variable "connector_measurements_header" {
  type    = string
  default = "X-OOB-Connector-Measurements"
}

variable "consent_id_portability_header" {
  type    = string
  default = "none"
}

variable "route_block_enabled" {
  type = bool
}

variable "mqd_event_enabled" {
  type = bool
}

variable "ocsp_validation_enabled" {
  type = bool
}

variable "ocsp_cache_ms_duration" {
  type = number
}

variable "ocsp_server_request_ms_timeout" {
  type = number
}

variable "ocsp_per_cert_server_request_ms_timeout" {
  type = string
}

variable "log_request_response_enabled" {
  type = bool
}

variable "log_request_response_collector_url_http" {
  type = string
}

variable "operational_limits_enabled" {
  type = bool
}

variable "operational_limits_allow_when_over_limit" {
  type = bool
}

variable "operational_limits_check_limit_timeout_ms" {
  type = number
}

variable "server_org_id" {
  type    = string
  default = ""
}

variable "pubsub_id" {
  type    = string
  default = ""
}

variable "dapr_large_event_store" {
  type    = string
  default = ""
}

variable "api_docs_enabled" {
  type    = bool
  default = false
}

variable "docs_route" {
  type    = string
  default = ""
}

variable "routes" {
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
