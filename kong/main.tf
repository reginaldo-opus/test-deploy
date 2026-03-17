terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# ============================================================================
# Locals: Build the full Kong declarative config as a native HCL structure,
# then render it to YAML for decK.
# ============================================================================

locals {
  brands_map = {
    for brand in var.brands :
    brand.brand_id => brand
  }

  component_prefix = var.component_prefix

  # ---------------------------------------------------------------------------
  # Global plugins
  # ---------------------------------------------------------------------------
  global_plugins = jsondecode(jsonencode(flatten([
    [
      {
        name      = "prometheus"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          per_consumer        = true
          status_code_metrics = true
          latency_metrics     = true
        }
      },
      {
        name      = "pre-function"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          access = [
            "kong.log.set_serialize_value(\"request.body\", kong.request.get_raw_body())"
          ]
          body_filter = [
            "kong.log.set_serialize_value(\"response.body\", kong.response.get_raw_body())"
          ]
        }
      },
      {
        name      = "rate-limiting"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          second              = var.transaction_limit_global_per_second
          limit_by            = "path"
          path                = "/"
          policy              = "local"
          hide_client_headers = true
          error_code          = 529
        }
      },
      {
        name      = "oob-kong-custom-metrics"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {}
      }
    ],
    var.opentelemetry_enabled ? [
      {
        name      = "opentelemetry"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          endpoint          = var.opentelemetry_tracer_exporter_url_http
          batch_span_count  = var.opentelemetry_batch_span_count
          batch_flush_delay = var.opentelemetry_batch_flush_delay_seconds
        }
      }
    ] : [],
  ])))
}

# ---------------------------------------------------------------------------
# Generate per-brand service configs via the deck_service module
# ---------------------------------------------------------------------------

module "brand_services" {
  source   = "./modules/deck_brand"
  for_each = local.brands_map

  brand                  = each.value
  component_prefix       = var.component_prefix
  cors_origins           = var.cors_origins
  transaction_limit_per_ip_per_minute = var.transaction_limit_per_ip_per_minute
  api_docs_enabled       = var.api_docs_enabled
  api_security_enabled   = var.api_security_enabled
  x_forwarded_for_header_name = var.x_forwarded_for_header_name
  expose_internal_apis   = var.expose_internal_apis
  must_have_fapi_interaction_id = var.must_have_fapi_interaction_id
  route_block_enabled    = var.route_block_enabled
  opentelemetry_enabled  = var.opentelemetry_enabled
}

# ---------------------------------------------------------------------------
# Merge all brands into one kong.yml structure and write to file
# ---------------------------------------------------------------------------

locals {
  all_services = flatten([for brand_key, brand_mod in module.brand_services : brand_mod.services])

  kong_config = {
    _format_version = "3.0"
    _transform      = true
    plugins         = local.global_plugins
    services        = local.all_services
  }
}

resource "local_file" "kong_yaml" {
  content  = yamlencode(local.kong_config)
  filename = "${path.module}/output/kong.yml"
}

output "kong_yaml_path" {
  value       = local_file.kong_yaml.filename
  description = "Path to the generated kong.yml file"
}

output "kong_yaml_content" {
  value       = yamlencode(local.kong_config)
  description = "Content of the generated kong.yml"
  sensitive   = true
}
