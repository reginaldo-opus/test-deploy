# ============================================================================
# deck_brand/variables.tf — Variáveis do Módulo Brand
#
# Recebe o objeto brand completo e variáveis globais.
# As variáveis de rotas permitem override das rotas padrão definidas
# em routes_defaults.tf — se vazias, usa os defaults.
# ============================================================================

variable "brand" {
  description = "Objeto completo do brand com toda a configuração (hosts, portas, FQDNs, features, etc.)"
  type        = any
}

variable "component_prefix" {
  type = string
}

variable "cors_origins" {
  type = string
}

variable "transaction_limit_per_ip_per_minute" {
  type = number
}

variable "api_docs_enabled" {
  type    = bool
  default = false
}

variable "api_security_enabled" {
  type    = bool
  default = true
}

variable "x_forwarded_for_header_name" {
  type    = string
  default = "X-Forwarded-For"
}

variable "expose_internal_apis" {
  type    = bool
  default = false
}

variable "must_have_fapi_interaction_id" {
  type    = string
  default = "never"
}

variable "route_block_enabled" {
  type    = bool
  default = true
}

variable "opentelemetry_enabled" {
  type    = bool
  default = true
}

# ---------------------------------------------------------------------------
# Route variables — default values mirror the original project's defaults.
# Users override these with their actual route definitions from tfvars.
# ---------------------------------------------------------------------------

variable "routes_status" {
  type    = any
  default = []
}

variable "routes_status_maintenance" {
  type    = any
  default = []
}

variable "routes_consent_payment" {
  type    = any
  default = []
}

variable "routes_consent_data_sharing_v2" {
  type    = any
  default = []
}

variable "routes_consent_data_sharing_v3" {
  type    = any
  default = []
}

variable "routes_consent_credit_portability" {
  type    = any
  default = []
}

variable "routes_consent_oob" {
  type    = any
  default = []
}

variable "routes_consent_as" {
  type    = any
  default = []
}

variable "routes_financial_data" {
  type    = any
  default = []
}

variable "routes_payment" {
  type    = any
  default = []
}

variable "routes_payment_oob" {
  type    = any
  default = []
}

variable "routes_payment_as" {
  type    = any
  default = []
}

variable "routes_open_data" {
  type    = any
  default = []
}

variable "routes_auth_server_fapi" {
  type    = any
  default = []
}

variable "routes_auth_server_fapi_mtls" {
  type    = any
  default = []
}

variable "routes_auth_server_non_fapi" {
  type    = any
  default = []
}

# ---------------------------------------------------------------------------
# Route override variables
#
# Se não-vazio, substitui as rotas padrão de routes_defaults.tf.
# Isso permite que diferentes ambientes (hml, prod) usem rotas diferentes.
# Os defaults (local.default_routes_*) cobrem todas as 283 rotas do
# Open Banking Brasil.
# ---------------------------------------------------------------------------

variable "routes_status" {
  type    = any
  default = []
}

variable "routes_status_maintenance" {
  type    = any
  default = []
}

variable "routes_consent_payment" {
  type    = any
  default = []
}

variable "routes_consent_data_sharing_v2" {
  type    = any
  default = []
}

variable "routes_consent_data_sharing_v3" {
  type    = any
  default = []
}

variable "routes_consent_credit_portability" {
  type    = any
  default = []
}

variable "routes_consent_oob" {
  type    = any
  default = []
}

variable "routes_consent_as" {
  type    = any
  default = []
}

variable "routes_financial_data" {
  type    = any
  default = []
}

variable "routes_payment" {
  type    = any
  default = []
}

variable "routes_payment_oob" {
  type    = any
  default = []
}

variable "routes_payment_as" {
  type    = any
  default = []
}

variable "routes_open_data" {
  type    = any
  default = []
}

variable "routes_auth_server_fapi" {
  type    = any
  default = []
}

variable "routes_auth_server_fapi_mtls" {
  type    = any
  default = []
}

variable "routes_auth_server_non_fapi" {
  type    = any
  default = []
}
