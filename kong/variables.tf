# ===========================================================================
# variables.tf — Kong Deck — Variáveis de Entrada
#
# Todas as variáveis configuráveis do projeto.
# Valores são definidos em terraform.tfvars (ou via CI/CD).
#
# Organização:
#   1. Kong Admin API (conexão com o Kong — usado apenas pelo script local)
#   2. Configurações gerais (CORS, rate limiting, features)
#   3. OpenTelemetry
#   4. Limites operacionais
#   5. Brands (multi-tenant)
#   6. Kubernetes / ArgoCD
# ===========================================================================

# ===========================================================================
# 1. KONG ADMIN API
#
# Estas variáveis são usadas pelo script deck-local-sync.sh para sync
# direto (sem Kubernetes). No fluxo GitOps, o endereço do Kong Admin
# é configurado diretamente no sync-job.yaml.
# ===========================================================================

variable "kong_admin_uri" {
  description = "URL da Kong Admin API (ex: http://kong-admin:8001)"
  type        = string
}

variable "kong_admin_tls_skip_verify" {
  description = "Ignorar verificação de certificado TLS da Admin API (útil em dev)"
  type        = bool
  default     = false
}

variable "kong_admin_token" {
  description = "(Opcional) Token de autenticação da Admin API (Kong Enterprise)"
  type        = string
  default     = ""
}

variable "kong_admin_username" {
  description = "(Opcional) Usuário para autenticação Basic na Admin API"
  type        = string
  default     = ""
}

variable "kong_admin_password" {
  description = "(Opcional) Senha para autenticação Basic na Admin API"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kong_api_key" {
  description = "(Opcional) API key para autenticação na Admin API"
  type        = string
  default     = ""
  sensitive   = true
}

# ===========================================================================
# 2. CONFIGURAÇÕES GERAIS
# ===========================================================================

variable "cors_origins" {
  description = "Origens permitidas no CORS (ex: '*' para dev, 'https://app.example.com' para prod)"
  type        = string
}

variable "transaction_limit_global_per_second" {
  description = "Limite global de requisições por segundo (rate limiting por path '/')"
  type        = number
}

variable "transaction_limit_per_ip_per_minute" {
  description = "Limite de requisições por minuto por IP (rate limiting por service)"
  type        = number
}

variable "api_docs_enabled" {
  description = "Habilitar rota de documentação da API (/api-docs). Geralmente false em produção."
  type        = bool
  default     = false
}

variable "api_security_enabled" {
  description = "Habilitar validação de segurança (token introspection, JWS). DEVE ser true em produção."
  type        = bool
  default     = true
}

variable "ssl_certificate_header_name" {
  description = "Header HTTP com o certificado do cliente (mTLS termination)"
  type        = string
  default     = "X-SSL-Client-Cert"
}

variable "x_forwarded_for_header_name" {
  description = "Header HTTP com o IP de origem do cliente"
  type        = string
  default     = "X-Forwarded-For"
}

variable "expose_internal_apis" {
  description = "Expor APIs internas (consent-as, payment-as). NUNCA habilitar em produção!"
  type        = bool
  default     = false
}

variable "component_prefix" {
  description = "Prefixo dos componentes (ex: 'oob'). Usado nos nomes de services e plugins."
  type        = string
}

variable "must_have_fapi_interaction_id" {
  description = "Data a partir da qual x-fapi-interaction-id é obrigatório (YYYY-MM-DD ou 'never')"
  type        = string
  default     = "never"
}

variable "route_block_enabled" {
  description = "Habilitar bloqueio de rotas por data regulatória (block_before_date / block_from_date)"
  type        = bool
  default     = true
}

variable "mqd_event_enabled" {
  description = "Habilitar publicação de eventos MQD (Métricas de Qualidade de Dados)"
  type        = bool
  default     = false
}

# ===========================================================================
# 3. OPENTELEMETRY
# ===========================================================================

variable "opentelemetry_enabled" {
  description = "Habilitar exportação de traces via OpenTelemetry"
  type        = bool
  default     = true
}

variable "opentelemetry_tracer_exporter_url_http" {
  description = "Endpoint HTTP do OpenTelemetry Collector (ex: http://otel-collector:4318/v1/traces)"
  type        = string
  default     = ""
}

variable "opentelemetry_batch_span_count" {
  description = "Número de spans por batch no OpenTelemetry"
  type        = number
  default     = 500
}

variable "opentelemetry_batch_flush_delay_seconds" {
  description = "Intervalo em segundos entre batches de spans do OpenTelemetry"
  type        = number
  default     = 3
}

# ===========================================================================
# 4. LIMITES OPERACIONAIS
# ===========================================================================

variable "operational_limits_enabled" {
  description = "Habilitar verificação de limites operacionais por rota"
  type        = bool
  default     = false
}

variable "operational_limits_allow_when_over_limit" {
  description = "Permitir requisições quando o limite operacional for atingido (true = não bloqueia)"
  type        = bool
  default     = false
}

variable "operational_limits_check_limit_timeout_ms" {
  description = "Timeout em milissegundos para verificar o limite operacional"
  type        = number
  default     = 100
}

# ===========================================================================
# 5. BRANDS (MULTI-TENANT)
#
# Cada brand representa um tenant/marca no Open Banking Brasil.
# Cada brand gera ~16 serviços Kong com ~283 rotas.
#
# Para adicionar um novo brand, adicione um novo objeto no array.
# As variáveis de entrada são 100% compatíveis com o projeto anterior (kong/).
# ===========================================================================

variable "brands" {
  type = list(object({
    brand_id                                = string  # Identificador único do brand
    oob_status_api_host                     = string  # Host da API de status
    oob_status_api_port                     = number  # Porta da API de status
    oob_consent_api_host                    = string  # Host da API de consentimento
    oob_consent_api_port                    = number  # Porta da API de consentimento
    oob_financial_data_api_host             = string  # Host da API de dados financeiros
    oob_financial_data_api_port             = number  # Porta da API de dados financeiros
    oob_payment_api_host                    = string  # Host da API de pagamento
    oob_payment_api_port                    = number  # Porta da API de pagamento
    oob_open_data_api_host                  = string  # Host da API de dados abertos
    oob_open_data_api_port                  = number  # Porta da API de dados abertos
    oob_authorization_server_host           = string  # Host do Authorization Server
    oob_authorization_server_port           = number  # Porta do Authorization Server
    introspection_client_id                 = string  # Client ID para token introspection
    introspection_client_secret             = string  # Client Secret para token introspection
    auth_server_url                         = string  # URL base do Auth Server (ex: https://auth.example.com)
    auth_server_base_path                   = string  # Base path FAPI (ex: /auth/)
    auth_server_nonfapi_base_path           = string  # Base path non-FAPI (ex: /auth/nonfapi/)
    public_fqdn                             = string  # FQDN público (ex: api.example.com)
    public_fqdn_mtls                        = string  # FQDN público mTLS (ex: mtls.example.com)
    internal_fqdn                           = string  # FQDN interno (ex: api.internal.example.com)
    supported_features                      = list(string)  # Features habilitadas (core, payments, etc.)
    server_org_id                           = string  # ID da organização no diretório
    pubsub_id                               = string  # ID do PubSub (Dapr)
    dapr_large_event_store                  = string  # Store para eventos grandes (Dapr)
    ssl_certificate_header_name             = string  # Header com certificado mTLS
    mqd_event_enabled                       = bool    # Habilitar eventos MQD para este brand
    ocsp_validation_enabled                 = bool    # Habilitar validação OCSP
    ocsp_cache_ms_duration                  = number  # Duração do cache OCSP em ms
    ocsp_server_request_ms_timeout          = number  # Timeout de requisição OCSP em ms
    ocsp_per_cert_server_request_ms_timeout = string  # Timeout OCSP por certificado
    log_request_response_enabled            = bool    # Habilitar log de request/response (http-log)
    log_request_response_collector_url_http = string  # URL do coletor de logs
    operational_limits_enabled              = bool    # Habilitar limites operacionais
    operational_limits_allow_when_over_limit = bool   # Permitir requisições acima do limite
    operational_limits_check_limit_timeout_ms = number # Timeout para verificar limite
  }))
  description = "Lista de brands/tenants. Cada brand gera um conjunto completo de serviços Kong."
}

# ===========================================================================
# 6. KUBERNETES / ARGOCD
#
# Variáveis usadas para referência nos manifests do ArgoCD.
# Não afetam a geração do kong.yaml.
# ===========================================================================

variable "deck_namespace" {
  description = "Namespace Kubernetes onde o Job do decK sync é executado"
  type        = string
  default     = "kong"
}

variable "deck_image" {
  description = "Imagem Docker do decK CLI (ex: kong/deck:v1.56.0)"
  type        = string
  default     = "kong/deck:latest"
}

variable "argocd_project" {
  description = "Nome do projeto ArgoCD"
  type        = string
  default     = "default"
}

variable "argocd_repo_url" {
  description = "URL do repositório Git para o ArgoCD"
  type        = string
  default     = ""
}

variable "argocd_target_revision" {
  description = "Branch/tag do Git para o ArgoCD (ex: 'main', 'v1.0.0')"
  type        = string
  default     = "main"
}
