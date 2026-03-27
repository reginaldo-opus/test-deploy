# ===========================================================================
# main.tf — Kong Deck — Gerador de Configuração Declarativa
#
# Este é o ponto de entrada do Terraform. Ele:
#   1. Recebe a lista de brands (tenants) via terraform.tfvars
#   2. Instancia o módulo deck_brand para cada brand
#   3. Mescla todas as configurações em um único kong.yaml
#   4. Comprime o YAML em kong.yaml.gz para uso como ConfigMap
#
# O kong.yaml gerado é compatível com decK (Kong declarative format v3.0).
#
# Provider: hashicorp/local (apenas gera arquivos locais — não faz API calls)
# ===========================================================================

terraform {
  required_providers {
    # Usamos apenas o provider "local" para gerar o arquivo kong.yaml.
    # Nenhuma chamada HTTP é feita — diferente do antigo provider greut/kong.
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
  # Transforma a lista de brands em um mapa indexado por brand_id.
  # Isso permite usar for_each no módulo (mais eficiente que count).
  brands_map = {
    for brand in var.brands :
    brand.brand_id => brand
  }

  component_prefix = var.component_prefix

  # ---------------------------------------------------------------------------
  # Global plugins — aplicados a TODAS as rotas do Kong.
  #
  # jsondecode(jsonencode(...)) é um padrão usado para normalizar tipos
  # dinâmicos do HCL e evitar erros de "inconsistent conditional result types"
  # quando usamos condicionais (ternários) dentro de listas.
  # ---------------------------------------------------------------------------
  global_plugins = jsondecode(jsonencode(flatten([
    [
      # Prometheus: métricas de latência, status code, e por consumer
      {
        name      = "prometheus"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {
          per_consumer        = true
          status_code_metrics = true
          latency_metrics     = true
        }
      },
      # Pre-function: serializa request/response body para logs
      # Usa kong.log.set_serialize_value para incluir o body nos logs
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
      # Rate limiting global: limite por path (raiz "/")
      # error_code 529 = "Site is overloaded" (não-padrão, específico OOB)
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
      # Métricas customizadas OOB (plugin Go customizado)
      {
        name      = "oob-kong-custom-metrics"
        protocols = ["grpc", "grpcs", "http", "https"]
        config = {}
      }
    ],
    # OpenTelemetry: condicional — só ativado se opentelemetry_enabled = true
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
# Instancia o módulo deck_brand para cada brand/tenant.
#
# Cada brand gera ~16 serviços Kong com ~283 rotas (Open Banking Brasil).
# O for_each usa o brands_map para iterar por brand_id.
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
# Merge all brands into one kong.yaml structure and write to file.
#
# A estrutura final segue o formato declarativo do decK v3.0:
#   _format_version: "3.0"
#   _transform: true         (permite transformações do decK)
#   plugins: [...]            (plugins globais)
#   services: [...]           (todos os serviços de todos os brands)
# ---------------------------------------------------------------------------

locals {
  # Flatten: transforma [[services_brand1], [services_brand2]] em [s1, s2, ...]
  all_services = flatten([for brand_key, brand_mod in module.brand_services : brand_mod.services])

  kong_config = {
    _format_version = "3.0"
    _transform      = true
    plugins         = local.global_plugins
    services        = local.all_services
  }
}

# ---------------------------------------------------------------------------
# Gera o arquivo kong.yaml no diretório output/
# Este é o artefato principal — a configuração declarativa completa do Kong.
# ---------------------------------------------------------------------------
resource "local_file" "kong_yaml" {
  content  = yamlencode(local.kong_config)
  filename = "${path.module}/output/kong.yaml"
}

# ---------------------------------------------------------------------------
# Gera kong.yaml.gz — versão comprimida para uso como ConfigMap.
#
# ConfigMaps no Kubernetes têm limite de 1MB no etcd.
# O gzip reduz ~98% do tamanho (ex: 26MB → 514KB).
#
# O Kustomize detecta automaticamente arquivos .gz como binários
# e os armazena em binaryData (base64) no ConfigMap.
#
# O sync-job.yaml usa um initContainer (busybox) para descomprimir
# o .gz antes de passar para o deck CLI.
# ---------------------------------------------------------------------------
resource "terraform_data" "kong_yaml_gz" {
  depends_on = [local_file.kong_yaml]

  provisioner "local-exec" {
    command = "gzip -9 -k -f ${local_file.kong_yaml.filename}"
  }
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------

output "kong_yaml_path" {
  value       = local_file.kong_yaml.filename
  description = "Caminho absoluto do arquivo kong.yaml gerado"
}

output "kong_yaml_content" {
  value       = yamlencode(local.kong_config)
  description = "Conteúdo do kong.yaml (sensível por conter secrets)"
  sensitive   = true
}
