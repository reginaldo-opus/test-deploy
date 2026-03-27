# ===========================================================================
# terraform.tfvars — Kong Deck — Configuração de Exemplo
#
# Arquivo com valores reais para o ambiente HML.
# Copie de terraform.tfvars.example e ajuste para seu ambiente.
#
# ATENÇÃO: Este arquivo contém secrets (introspection_client_secret).
# Ele está no .gitignore e NÃO deve ser commitado.
# Em produção, use variáveis de ambiente ou Vault.
# ===========================================================================

# ---------------------------------------------------------------------------
# Kong Admin API (usado pelo script deck-local-sync.sh)
# ---------------------------------------------------------------------------
kong_admin_uri             = "http://kong-admin:8001"
kong_admin_tls_skip_verify = false
kong_admin_token           = ""
kong_admin_username        = ""
kong_admin_password        = ""
kong_api_key               = ""

# ---------------------------------------------------------------------------
# Geral
# ---------------------------------------------------------------------------
component_prefix = "oob"

cors_origins                        = "*"
transaction_limit_global_per_second = 300
transaction_limit_per_ip_per_minute = 120

api_docs_enabled     = false
api_security_enabled = true
expose_internal_apis = false

must_have_fapi_interaction_id = "never"
route_block_enabled           = true

# ---------------------------------------------------------------------------
# OpenTelemetry
# ---------------------------------------------------------------------------
opentelemetry_enabled                   = true
opentelemetry_tracer_exporter_url_http  = "http://otel-collector:4318/v1/traces"
opentelemetry_batch_span_count          = 500
opentelemetry_batch_flush_delay_seconds = 3

# ---------------------------------------------------------------------------
# ArgoCD / Kubernetes
# ---------------------------------------------------------------------------
deck_namespace         = "kong"
deck_image             = "kong/deck:v1.56.0"
argocd_project         = "default"
argocd_repo_url        = "https://github.com/reginaldo-opus/test-deploy.git"
argocd_target_revision = "main"

# ===========================================================================
# Brands — um entry por brand/tenant
#
# Cada brand gera ~16 serviços Kong com ~283 rotas.
# Para adicionar um novo brand, copie um bloco e ajuste os valores.
#
# Campos obrigatórios:
#   brand_id             — ID único (usado no nome do service Kong)
#   public_fqdn          — Domínio público (rotas HTTP)
#   public_fqdn_mtls     — Domínio mTLS (rotas com certificado)
#   internal_fqdn        — Domínio interno (APIs internas)
#   supported_features   — Features habilitadas (filtra rotas criadas)
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
    introspection_client_id        = "introspection-client-1"
    introspection_client_secret    = "introspection-secret-1"
    auth_server_url                = "https://auth-brand1.opus.com.br"
    auth_server_base_path          = "/auth/"
    auth_server_nonfapi_base_path  = "/auth/nonfapi/"
    public_fqdn                    = "api-brand1.opus.com.br"
    public_fqdn_mtls               = "mtls-brand1.opus.com.br"
    internal_fqdn                  = "api.internal-brand1.opus.com.br"
    supported_features             = ["core", "open-data", "financial-data", "payments", "enrollments"]
    server_org_id                  = "org-1"
    pubsub_id                      = "pubsub-1"
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
    introspection_client_id        = "introspection-client-2"
    introspection_client_secret    = "introspection-secret-2"
    auth_server_url                = "https://auth-brand2.opus.com.br"
    auth_server_base_path          = "/auth/"
    auth_server_nonfapi_base_path  = "/auth/nonfapi/"
    public_fqdn                    = "api-brand2.opus.com.br"
    public_fqdn_mtls               = "mtls-brand2.opus.com.br"
    internal_fqdn                  = "api.internal-brand2.opus.com.br"
    supported_features             = ["core", "open-data", "financial-data", "payments", "enrollments"]
    server_org_id                  = "org-2"
    pubsub_id                      = "pubsub-2"
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
