# ===========================================================================
# Example terraform.tfvars for kong-deck project
#
# Copy this file to terraform.tfvars and adjust values for your environment.
# The route definitions (routes_*) should be passed via the deck_brand module
# variables — they use the same format as the original Terraform Kong project.
# ===========================================================================

kong_admin_uri             = "http://kong-admin:8001"
kong_admin_tls_skip_verify = false
kong_admin_token           = ""
kong_admin_username        = ""
kong_admin_password        = ""
kong_api_key               = ""

component_prefix = "oob"

cors_origins                        = "*"
transaction_limit_global_per_second = 300
transaction_limit_per_ip_per_minute = 120

api_docs_enabled     = false
api_security_enabled = true
expose_internal_apis = false

must_have_fapi_interaction_id = "never"
route_block_enabled           = true

opentelemetry_enabled                   = true
opentelemetry_tracer_exporter_url_http  = "http://otel-collector:4318/v1/traces"
opentelemetry_batch_span_count          = 500
opentelemetry_batch_flush_delay_seconds = 3

# ArgoCD / Kubernetes
deck_namespace         = "kong"
deck_image             = "kong/deck:latest"
argocd_project         = "default"
argocd_repo_url        = "https://github.com/reginaldo-opus/test-deploy.git"
argocd_target_revision = "main"

# ===========================================================================
# Brands — one entry per brand / tenant
# ===========================================================================
brands = [
  {
    brand_id                       = "brand1"
    oob_status_api_host            = "oob-status"
    oob_status_api_port            = 8080
    oob_consent_api_host           = "oob-consent"
    oob_consent_api_port           = 8080
    oob_financial_data_api_host    = "oob-financial-data"
    oob_financial_data_api_port    = 8080
    oob_payment_api_host           = "oob-payment"
    oob_payment_api_port           = 8080
    oob_open_data_api_host         = "oob-open-data"
    oob_open_data_api_port         = 8080
    oob_authorization_server_host  = "oob-auth-server"
    oob_authorization_server_port  = 8080
    introspection_client_id        = "introspection-client"
    introspection_client_secret    = "introspection-secret"
    auth_server_url                = "https://auth.opus.com.br"
    auth_server_base_path          = "/auth/"
    auth_server_nonfapi_base_path  = "/auth/nonfapi/"
    public_fqdn                    = "api.opus.com.br"
    public_fqdn_mtls               = "mtls.opus.com.br"
    internal_fqdn                  = "api.internal.opus.com.br"
    supported_features             = ["core", "open-data", "financial-data", "payments", "enrollments"]
    server_org_id                  = "org-123"
    pubsub_id                      = "pubsub"
    dapr_large_event_store         = "large-event-store"
    ssl_certificate_header_name    = "X-SSL-Client-Cert"
    mqd_event_enabled              = false
    ocsp_validation_enabled        = false
    ocsp_cache_ms_duration         = 3600000
    ocsp_server_request_ms_timeout = 5000
    ocsp_per_cert_server_request_ms_timeout = "default=5000"
    log_request_response_enabled   = false
    log_request_response_collector_url_http = "http://log-collector:8080/logs"
    operational_limits_enabled              = false
    operational_limits_allow_when_over_limit = false
    operational_limits_check_limit_timeout_ms = 100
  },
  {
    brand_id                       = "brand2"
    oob_status_api_host            = "oob-status"
    oob_status_api_port            = 8080
    oob_consent_api_host           = "oob-consent"
    oob_consent_api_port           = 8080
    oob_financial_data_api_host    = "oob-financial-data"
    oob_financial_data_api_port    = 8080
    oob_payment_api_host           = "oob-payment"
    oob_payment_api_port           = 8080
    oob_open_data_api_host         = "oob-open-data"
    oob_open_data_api_port         = 8080
    oob_authorization_server_host  = "oob-auth-server"
    oob_authorization_server_port  = 8080
    introspection_client_id        = "introspection-client"
    introspection_client_secret    = "introspection-secret"
    auth_server_url                = "https://auth.2-opus.com.br"
    auth_server_base_path          = "/auth/"
    auth_server_nonfapi_base_path  = "/auth/nonfapi/"
    public_fqdn                    = "api.2-opus.com.br"
    public_fqdn_mtls               = "mtls.2-opus.com.br"
    internal_fqdn                  = "api.internal.2-opus.com.br"
    supported_features             = ["core", "open-data", "financial-data", "payments", "enrollments"]
    server_org_id                  = "org-123"
    pubsub_id                      = "pubsub"
    dapr_large_event_store         = "large-event-store"
    ssl_certificate_header_name    = "X-SSL-Client-Cert"
    mqd_event_enabled              = false
    ocsp_validation_enabled        = false
    ocsp_cache_ms_duration         = 3600000
    ocsp_server_request_ms_timeout = 5000
    ocsp_per_cert_server_request_ms_timeout = "default=5000"
    log_request_response_enabled   = false
    log_request_response_collector_url_http = "http://log-collector:8080/logs"
    operational_limits_enabled              = false
    operational_limits_allow_when_over_limit = false
    operational_limits_check_limit_timeout_ms = 100
  }
]
