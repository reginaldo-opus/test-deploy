# ============================================================================
# deck_brand module
#
# Receives a single brand object and produces the full list of Kong services,
# routes, and plugins for that brand.  Output is a list of HCL maps that get
# merged into the top-level kong.yaml.
# ============================================================================

locals {
  brand_id         = var.brand.brand_id
  component_prefix = var.component_prefix

  # Connector measurements header — used by services that need PCM events
  connector_measurements_header = "X-OOB-Connector-Measurements"
  consent_id_portability_header = "X-Consent-Id-Portability"
}

# ============================================================================
# Sub-modules for each service domain
# ============================================================================

module "status" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "status"
  service_host       = var.brand.oob_status_api_host
  service_port       = var.brand.oob_status_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  api_docs_enabled = var.api_docs_enabled
  docs_route       = "/open-banking/status/api-docs"

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_status) > 0 ? var.routes_status : local.default_routes_status
}

module "status_maintenance" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "status-maintenance"
  service_host       = var.brand.oob_status_api_host
  service_port       = var.brand.oob_status_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = true

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = "none"
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_status_maintenance) > 0 ? var.routes_status_maintenance : local.default_routes_status_maintenance
}

module "consent_payment" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-payment"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  api_docs_enabled = var.api_docs_enabled
  docs_route       = "/open-banking/consent/api-docs"

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_payment) > 0 ? var.routes_consent_payment : local.default_routes_consent_payment
}

module "consent_data_sharing_v2" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-data-sharing-v2"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_data_sharing_v2) > 0 ? var.routes_consent_data_sharing_v2 : local.default_routes_consent_data_sharing_v2
}

module "consent_data_sharing_v3" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-data-sharing-v3"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_data_sharing_v3) > 0 ? var.routes_consent_data_sharing_v3 : local.default_routes_consent_data_sharing_v3
}

module "consent_credit_portability" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-credit-portability"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = local.consent_id_portability_header
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_credit_portability) > 0 ? var.routes_consent_credit_portability : local.default_routes_consent_credit_portability
}

module "consent_oob" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-${local.component_prefix}"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn, var.brand.internal_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = true

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = "none"
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_oob) > 0 ? var.routes_consent_oob : local.default_routes_consent_oob
}

module "consent_as" {
  source = "../deck_service"
  count  = var.expose_internal_apis ? 1 : 0

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "consent-as"
  service_host       = var.brand.oob_consent_api_host
  service_port       = var.brand.oob_consent_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = true

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = "none"
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_consent_as) > 0 ? var.routes_consent_as : local.default_routes_consent_as
}

module "financial_data" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "financial-data"
  service_host       = var.brand.oob_financial_data_api_host
  service_port       = var.brand.oob_financial_data_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  api_docs_enabled = var.api_docs_enabled
  docs_route       = "/open-banking/financial-data/api-docs"

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_financial_data) > 0 ? var.routes_financial_data : local.default_routes_financial_data
}

module "payment" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "payment"
  service_host       = var.brand.oob_payment_api_host
  service_port       = var.brand.oob_payment_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  api_docs_enabled = var.api_docs_enabled
  docs_route       = "/open-banking/payment/api-docs"

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_payment) > 0 ? var.routes_payment : local.default_routes_payment
}

module "payment_oob" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "payment-${local.component_prefix}"
  service_host       = var.brand.oob_payment_api_host
  service_port       = var.brand.oob_payment_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn, var.brand.internal_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = true

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = "none"
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_payment_oob) > 0 ? var.routes_payment_oob : local.default_routes_payment_oob
}

module "payment_as" {
  source = "../deck_service"
  count  = var.expose_internal_apis ? 1 : 0

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "payment-as"
  service_host       = var.brand.oob_payment_api_host
  service_port       = var.brand.oob_payment_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = true

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = "none"
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_payment_as) > 0 ? var.routes_payment_as : local.default_routes_payment_as
}

module "open_data" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "open_data"
  service_host       = var.brand.oob_open_data_api_host
  service_port       = var.brand.oob_open_data_api_port
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  api_docs_enabled = var.api_docs_enabled
  docs_route       = "/open-banking/open-data/api-docs"

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_open_data) > 0 ? var.routes_open_data : local.default_routes_open_data
}

# Auth server has special handling for route_base_path from the auth_server_url
locals {
  auth_server_url_parsed = regex("^([^:/?#]+):?//?([^/:?#]*)(:(\\d*))?", var.brand.auth_server_url)
  auth_service_protocol  = local.auth_server_url_parsed[0]
}

module "auth_server_fapi" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "auth-server-fapi"
  service_protocol   = local.auth_service_protocol
  service_host       = var.brand.oob_authorization_server_host
  service_port       = var.brand.oob_authorization_server_port
  route_base_path    = "~${var.brand.auth_server_base_path}"
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn, var.brand.internal_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_auth_server_fapi) > 0 ? var.routes_auth_server_fapi : local.default_routes_auth_server_fapi
}

module "auth_server_fapi_mtls" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "auth-server-fapi-mtls"
  service_protocol   = local.auth_service_protocol
  service_host       = var.brand.oob_authorization_server_host
  service_port       = var.brand.oob_authorization_server_port
  route_base_path    = "~${var.brand.auth_server_base_path}"
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn_mtls]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = var.brand.ocsp_validation_enabled
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_auth_server_fapi_mtls) > 0 ? var.routes_auth_server_fapi_mtls : local.default_routes_auth_server_fapi_mtls
}

module "auth_server_non_fapi" {
  source = "../deck_service"

  brand_id           = local.brand_id
  component_prefix   = local.component_prefix
  service_name       = "auth-server-non-fapi"
  service_protocol   = local.auth_service_protocol
  service_host       = var.brand.oob_authorization_server_host
  service_port       = var.brand.oob_authorization_server_port
  route_base_path    = "~${var.brand.auth_server_nonfapi_base_path}"
  cors_origins       = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  public_fqdns       = [var.brand.public_fqdn, var.brand.internal_fqdn]
  supported_features = var.brand.supported_features
  internal_api       = false

  auth_server_url             = var.brand.auth_server_url
  auth_server_base_path       = var.brand.auth_server_base_path
  introspection_client_id     = var.brand.introspection_client_id
  introspection_client_secret = var.brand.introspection_client_secret
  api_security_enabled        = var.api_security_enabled
  ssl_certificate_header_name = var.brand.ssl_certificate_header_name
  x_forwarded_for_header_name = var.x_forwarded_for_header_name

  must_have_fapi_interaction_id = "never"
  connector_measurements_header = local.connector_measurements_header
  consent_id_portability_header = "none"
  route_block_enabled           = var.route_block_enabled
  mqd_event_enabled             = var.brand.mqd_event_enabled
  ocsp_validation_enabled       = false
  ocsp_cache_ms_duration        = var.brand.ocsp_cache_ms_duration
  ocsp_server_request_ms_timeout = var.brand.ocsp_server_request_ms_timeout
  ocsp_per_cert_server_request_ms_timeout = var.brand.ocsp_per_cert_server_request_ms_timeout
  log_request_response_enabled            = var.brand.log_request_response_enabled
  log_request_response_collector_url_http = var.brand.log_request_response_collector_url_http
  operational_limits_enabled              = var.brand.operational_limits_enabled
  operational_limits_allow_when_over_limit = var.brand.operational_limits_allow_when_over_limit
  operational_limits_check_limit_timeout_ms = var.brand.operational_limits_check_limit_timeout_ms

  server_org_id          = var.brand.server_org_id
  pubsub_id              = var.brand.pubsub_id
  dapr_large_event_store = var.brand.dapr_large_event_store

  routes = length(var.routes_auth_server_non_fapi) > 0 ? var.routes_auth_server_non_fapi : local.default_routes_auth_server_non_fapi
}

# ============================================================================
# Output: merge all services into a flat list
# ============================================================================

output "services" {
  value = flatten(concat(
    module.status.services,
    module.status_maintenance.services,
    module.consent_payment.services,
    module.consent_data_sharing_v2.services,
    module.consent_data_sharing_v3.services,
    module.consent_credit_portability.services,
    module.consent_oob.services,
    flatten([for m in module.consent_as : m.services]),
    module.financial_data.services,
    module.payment.services,
    module.payment_oob.services,
    flatten([for m in module.payment_as : m.services]),
    module.open_data.services,
    module.auth_server_fapi.services,
    module.auth_server_fapi_mtls.services,
    module.auth_server_non_fapi.services,
  ))
}
