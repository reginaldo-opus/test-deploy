variable "kong_admin_uri" {
  description = "Kong Admin URL"
  type        = string
}

variable "kong_admin_tls_skip_verify" {
  description = "Whether to skip TLS certificate verification for the Kong admin API when using HTTPS"
  type        = bool
  default     = false
}

variable "kong_admin_token" {
  description = "(Optional) API key used to secure the Kong admin API in the Enterprise Edition"
  type        = string
  default     = ""
}

variable "kong_admin_username" {
  description = "(Optional) The username for the Kong admin API"
  type        = string
  default     = ""
}

variable "kong_admin_password" {
  description = "(Optional) The password for the Kong admin API"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kong_api_key" {
  description = "(Optional) API key used to secure the Kong admin API"
  type        = string
  default     = ""
  sensitive   = true
}

variable "cors_origins" {
  description = "Allowed origins in CORS headers"
  type        = string
}

variable "transaction_limit_global_per_second" {
  description = "Transactions per second limit shared by all clients"
  type        = number
}

variable "transaction_limit_per_ip_per_minute" {
  description = "Transactions per minute limit per client IP"
  type        = number
}

variable "api_docs_enabled" {
  description = "Whether the API documentation should be enabled or not"
  type        = bool
  default     = false
}

variable "api_security_enabled" {
  description = "Whether to enable request validation (token introspection, JWS validation) on Kong"
  type        = bool
  default     = true
}

variable "ssl_certificate_header_name" {
  description = "HTTP header where the client certificate will be sent by the mTLS termination component"
  type        = string
  default     = "X-SSL-Client-Cert"
}

variable "x_forwarded_for_header_name" {
  description = "HTTP header responsible for identifying the originating IP address of a client request"
  type        = string
  default     = "X-Forwarded-For"
}

variable "expose_internal_apis" {
  description = "Expose internal APIs in development environments. MUST NOT be enabled in productive environments."
  type        = bool
  default     = false
}

variable "brands" {
  type = list(object({
    brand_id                                = string
    oob_status_api_host                     = string
    oob_status_api_port                     = number
    oob_consent_api_host                    = string
    oob_consent_api_port                    = number
    oob_financial_data_api_host             = string
    oob_financial_data_api_port             = number
    oob_payment_api_host                    = string
    oob_payment_api_port                    = number
    oob_open_data_api_host                  = string
    oob_open_data_api_port                  = number
    oob_authorization_server_host           = string
    oob_authorization_server_port           = number
    introspection_client_id                 = string
    introspection_client_secret             = string
    auth_server_url                         = string
    auth_server_base_path                   = string
    auth_server_nonfapi_base_path           = string
    public_fqdn                             = string
    public_fqdn_mtls                        = string
    internal_fqdn                           = string
    supported_features                      = list(string)
    server_org_id                           = string
    pubsub_id                               = string
    dapr_large_event_store                  = string
    ssl_certificate_header_name             = string
    mqd_event_enabled                       = bool
    ocsp_validation_enabled                 = bool
    ocsp_cache_ms_duration                  = number
    ocsp_server_request_ms_timeout          = number
    ocsp_per_cert_server_request_ms_timeout = string
    log_request_response_enabled            = bool
    log_request_response_collector_url_http = string
    operational_limits_enabled              = bool
    operational_limits_allow_when_over_limit = bool
    operational_limits_check_limit_timeout_ms = number
  }))
  description = "Brands"
}

variable "component_prefix" {
  description = "Component name prefix"
  type        = string
}

variable "must_have_fapi_interaction_id" {
  description = "Activates validation for empty x-fapi-interaction-id header since given date (YYYY-MM-DD)"
  type        = string
  default     = "never"
}

variable "route_block_enabled" {
  description = "Whether to enable routes block due to regulatory dates"
  type        = bool
  default     = true
}

variable "mqd_event_enabled" {
  description = "Whether MQD events are enabled or not for the installation"
  type        = bool
  default     = false
}

variable "opentelemetry_enabled" {
  description = "Whether to enable opentelemetry trace export"
  type        = bool
  default     = true
}

variable "opentelemetry_tracer_exporter_url_http" {
  description = "URL to send opentelemetry trace reports"
  type        = string
  default     = ""
}

variable "opentelemetry_batch_span_count" {
  description = "Opentelemetry batch span count"
  type        = number
  default     = 500
}

variable "opentelemetry_batch_flush_delay_seconds" {
  description = "Opentelemetry delay, in seconds, between two consecutive batches"
  type        = number
  default     = 3
}

variable "operational_limits_enabled" {
  description = "Whether operational limits is enabled or not for the brand"
  type        = bool
  default     = false
}

variable "operational_limits_allow_when_over_limit" {
  description = "Whether should allow or not requests to proceed when operational limit is reached"
  type        = bool
  default     = false
}

variable "operational_limits_check_limit_timeout_ms" {
  description = "Timeout in milliseconds for the operational limits check"
  type        = number
  default     = 100
}

# ---------------------------------------------------------------------------
# Kubernetes / ArgoCD specific
# ---------------------------------------------------------------------------

variable "deck_namespace" {
  description = "Kubernetes namespace for the decK sync Job"
  type        = string
  default     = "kong"
}

variable "deck_image" {
  description = "Docker image for decK CLI"
  type        = string
  default     = "kong/deck:latest"
}

variable "argocd_project" {
  description = "ArgoCD project name"
  type        = string
  default     = "default"
}

variable "argocd_repo_url" {
  description = "Git repository URL for ArgoCD"
  type        = string
  default     = ""
}

variable "argocd_target_revision" {
  description = "Git revision (branch/tag) for ArgoCD"
  type        = string
  default     = "main"
}
