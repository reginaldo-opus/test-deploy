# Relatório de Compatibilidade: Kong Terraform (antigo) vs Kong Deck (novo)

**Data:** 13 de março de 2026  
**Escopo:** Validação completa de plugins, rotas, services e configurações entre a instalação legada (`kong/`) via provider Terraform `greut/kong` e a instalação moderna (`kong-deck/`) via decK declarativo.

---

## 1. Resumo Executivo

| Critério | Resultado |
|----------|-----------|
| **Plugins globais** | 100% compatível |
| **Services** | 100% compatível (16/16) |
| **Rotas** | 100% compatível (283/283 pares nome+método) |
| **Plugins por serviço** | 100% compatível |
| **Plugins por rota** | 100% compatível |
| **Variáveis (tfvars)** | 100% compatível (bloco `brands` idêntico) |
| **Veredicto** | **MIGRAÇÃO SEGURA — sem perda funcional** |

---

## 2. Plugins Globais

| Plugin | Antigo (`kong/`) | Novo (`kong-deck/`) | Status |
|--------|-----------------|---------------------|--------|
| `prometheus` | `per_consumer=true`, `status_code_metrics=true`, `latency_metrics=true` | Idêntico | ✅ OK |
| `pre-function` | `access`: serializa request body; `body_filter`: serializa response body | Idêntico | ✅ OK |
| `rate-limiting` (global) | `second=var`, `limit_by=path`, `path=/`, `policy=local`, `hide_client_headers=true`, `error_code=529` | Idêntico | ✅ OK |
| `oob-kong-custom-metrics` | Sem config extra | `config = {}` (equivalente) | ✅ OK |
| `opentelemetry` | Condicional via `var.opentelemetry_enabled`; `endpoint`, `batch_span_count`, `batch_flush_delay` | Idêntico | ✅ OK |

> **Nota:** O novo formato adiciona `protocols = ["grpc", "grpcs", "http", "https"]` explicitamente nos plugins globais. Isso é uma melhoria de clareza — torna explícito o que o Kong já fazia por default.

---

## 3. Services — Mapeamento 1:1

### 3.1 Serviços ativos (16 total)

| Serviço Antigo (módulo) | Serviço Novo (deck_brand) | Nome no Kong | Compatível |
|------------------------|--------------------------|--------------|------------|
| `oob_service_status` → status | `module.status` | `{brand}.oob-status` | ✅ |
| `oob_service_status` → status-maintenance | `module.status_maintenance` | `{brand}.oob-status-maintenance` | ✅ |
| `oob_service_consent` → consent-payment | `module.consent_payment` | `{brand}.oob-consent-payment` | ✅ |
| `oob_service_consent` → consent-data-sharing-v2 | `module.consent_data_sharing_v2` | `{brand}.oob-consent-data-sharing-v2` | ✅ |
| `oob_service_consent` → consent-data-sharing-v3 | `module.consent_data_sharing_v3` | `{brand}.oob-consent-data-sharing-v3` | ✅ |
| `oob_service_consent` → consent-credit-portability | `module.consent_credit_portability` | `{brand}.oob-consent-credit-portability` | ✅ |
| `oob_service_consent` → consent-oob | `module.consent_oob` | `{brand}.oob-consent-oob` | ✅ |
| `oob_service_consent` → consent-as | `module.consent_as` (count) | `{brand}.oob-consent-as` | ✅ |
| `oob_service_financial_data` → financial-data | `module.financial_data` | `{brand}.oob-financial-data` | ✅ |
| `oob_service_payment` → payment | `module.payment` | `{brand}.oob-payment` | ✅ |
| `oob_service_payment` → payment-oob | `module.payment_oob` | `{brand}.oob-payment-oob` | ✅ |
| `oob_service_payment` → payment-as | `module.payment_as` (count) | `{brand}.oob-payment-as` | ✅ |
| `oob_service_open_data` → open_data | `module.open_data` | `{brand}.oob-open_data` | ✅ |
| `oob_service_auth_server` → auth-server-fapi | `module.auth_server_fapi` | `{brand}.oob-auth-server-fapi` | ✅ |
| `oob_service_auth_server` → auth-server-fapi-mtls | `module.auth_server_fapi_mtls` | `{brand}.oob-auth-server-fapi-mtls` | ✅ |
| `oob_service_auth_server` → auth-server-non-fapi | `module.auth_server_non_fapi` | `{brand}.oob-auth-server-non-fapi` | ✅ |

### 3.2 Serviços condicionais

| Serviço | Condição | Antigo | Novo | Status |
|---------|----------|--------|------|--------|
| `consent-as` | `expose_internal_apis = true` | `count = var.expose_internal_apis ? 1 : 0` | `count = var.expose_internal_apis ? 1 : 0` | ✅ Idêntico |
| `payment-as` | `expose_internal_apis = true` | `count = var.expose_internal_apis ? 1 : 0` | `count = var.expose_internal_apis ? 1 : 0` | ✅ Idêntico |

### 3.3 Propriedades do service

| Propriedade | Antigo | Novo | Status |
|------------|--------|------|--------|
| `name` | `{brand_id}.{prefix}-{service_name}` | Idêntico | ✅ |
| `protocol` | `http` (default) | `http` (default) | ✅ |
| `host` | Via variável | Via `brand.oob_*_api_host` | ✅ |
| `port` | Via variável | Via `brand.oob_*_api_port` | ✅ |

---

## 4. Rotas — Comparação Detalhada

### 4.1 Contagem por serviço

| Serviço | Antigo | Novo | Diferença |
|---------|--------|------|-----------|
| status | 3 | 3 | 0 |
| status-maintenance | 11 | 11 | 0 |
| consent-payment | 22 | 22 | 0 |
| consent-data-sharing-v2 | 6 | 6 | 0 |
| consent-data-sharing-v3 | 6 | 6 | 0 |
| consent-credit-portability | 14 | 14 | 0 |
| consent-oob | 32 | 32 | 0 |
| consent-as | 26 | 26 | 0 |
| financial-data | 68 | 68 | 0 |
| payment | 20 | 20 | 0 |
| payment-oob | 1 | 1 | 0 |
| payment-as | 1 | 1 | 0 |
| open_data | 30 | 30 | 0 |
| auth-server-fapi | 24 | 24 | 0 |
| auth-server-fapi-mtls | 9 | 9 | 0 |
| auth-server-non-fapi | 10 | 10 | 0 |
| **TOTAL** | **283** | **283** | **0** |

> **Verificação automatizada:** Todos os 283 pares (nome + método HTTP) foram validados por script e são idênticos entre as duas versões.

### 4.2 Propriedades da rota

| Propriedade | Antigo | Novo | Status |
|------------|--------|------|--------|
| `name` | `{brand}.{prefix}-{svc}_{METHOD}-{route_name}` | Idêntico | ✅ |
| `protocols` | `["http", "https"]` | `["http", "https"]` | ✅ |
| `paths` | Via route definitions | Idêntico | ✅ |
| `hosts` | FQDNs filtradas via `compact()` | FQDNs filtradas via `[for h in ... if h != ""]` | ✅ |
| `methods` | `[method, "OPTIONS"]` | `[method, "OPTIONS"]` | ✅ |
| `strip_path` | `false` | `false` | ✅ |

### 4.3 FQDNs por tipo de serviço

| Tipo | Host(s) utilizado(s) | Antigo | Novo | Status |
|------|---------------------|--------|------|--------|
| Público (status, open-data) | `public_fqdn` | ✅ | ✅ | ✅ |
| mTLS (consent, payment, financial-data) | `public_fqdn_mtls` | ✅ | ✅ | ✅ |
| Interno (consent-oob, payment-oob) | `public_fqdn` + `internal_fqdn` | ✅ | ✅ | ✅ |
| Auth Server (fapi, non-fapi) | `public_fqdn` + `internal_fqdn` | ✅ | ✅ | ✅ |
| Auth Server mTLS | `public_fqdn_mtls` | ✅ | ✅ | ✅ |

---

## 5. Plugins por Serviço (Service-Level)

| Plugin | Condição | Config Antigo | Config Novo | Status |
|--------|----------|--------------|-------------|--------|
| `cors` | Sempre (se hasRoutes) | `origins=[cors_origins]`, `methods=[GET,POST,PUT,DELETE,PATCH]` | Idêntico | ✅ |
| `rate-limiting` (per-IP) | Sempre (se hasRoutes) | `minute=var`, `limit_by=ip`, `policy=local`, `hide_client_headers=true` | Idêntico | ✅ |
| `{prefix}-error-handler` | `!internal_api` | Sem config | Idêntico | ✅ |
| `{prefix}-fapi-interaction-id` | Sempre | `musthavefapiinteractionid=var` | Idêntico | ✅ |
| `oob-kong-consumer-handler` | Sempre | `sslcertificateheadername=var` | Idêntico | ✅ |
| `{prefix}-ocsp-validator` | `ocsp_validation_enabled` | `sslcertificateheadername`, `ocspcachemsduration`, `ocspserverrequestmstimeout`, `ocsppercertserverrequestmstimeout` | Idêntico | ✅ |

### 5.1 FAPI Interaction ID — valores por serviço

| Serviço | Valor `must_have_fapi_interaction_id` | Antigo | Novo | Status |
|---------|---------------------------------------|--------|------|--------|
| status, status-maintenance | `"never"` (fixo) | ✅ | ✅ | ✅ |
| consent-payment | `var.must_have_fapi_interaction_id` | ✅ | ✅ | ✅ |
| consent-data-sharing-v2 | `"never"` (fixo) | ✅ | ✅ | ✅ |
| consent-data-sharing-v3 | `var.must_have_fapi_interaction_id` | ✅ | ✅ | ✅ |
| consent-credit-portability | `var.must_have_fapi_interaction_id` | ✅ | ✅ | ✅ |
| consent-oob, consent-as | `"never"` (fixo) | ✅ | ✅ | ✅ |
| financial-data | `var.must_have_fapi_interaction_id` | ✅ | ✅ | ✅ |
| payment | `var.must_have_fapi_interaction_id` | ✅ | ✅ | ✅ |
| payment-oob, payment-as | `"never"` (fixo) | ✅ | ✅ | ✅ |
| open_data | `"never"` (fixo) | ✅ | ✅ | ✅ |
| auth-server-* | `"never"` (fixo) | ✅ | ✅ | ✅ |

---

## 6. Plugins por Rota (Route-Level)

| Plugin | Condição de ativação | Campos de configuração | Antigo | Novo | Status |
|--------|---------------------|----------------------|--------|------|--------|
| `{prefix}-token-introspection` | `length(scopes) > 0 && api_security_enabled` | `authserverurl`, `authserverbasepath`, `clientid`, `clientsecret`, `scopes`, `certificateheader`, `mustvalidatejws` | ✅ | ✅ | ✅ |
| `request-transformer` | Sempre | Remove: `X-Brand-ID`, `Accept` (se JWT), `Content-Type` (se GET); Add: `X-Brand-ID:{brand}`, `Content-Type:application/json` (se JSON), `Accept:application/jwt` (se JWT) | ✅ | ✅ | ✅ |
| `response-transformer` | Sempre | Remove: `connector_measurements_header`, `consent_id_portability_header`; Add: `x-v:{api_version}` | ✅ | ✅ | ✅ |
| `{prefix}-api-event` (PCM) | `must_report_pcm` | `brandid`, `sslcertificateheadername`, `xforwardedforheadername`, `xconnectormeasurementsheader`, `serverorgid`, `pubsubid`, `xconsentidportabilityheader` | ✅ | ✅ | ✅ |
| `{prefix}-mqd-event` | `mqd_event_enabled && must_report_mqd` | `sslcertificateheadername`, `serverorgid`, `pubsubid`, `largeeventstatestorename` | ✅ | ✅ | ✅ |
| `{prefix}-route-block` | `route_block_enabled && (block_before_date != "none" \|\| block_from_date != "none")` | `blockbeforedate`, `blockfromdate` | ✅ | ✅ | ✅ |
| `http-log` | `log_request_response_enabled && must_log_request_response` | `http_endpoint` | ✅ | ✅ | ✅ |
| `{prefix}-operational-limits` | `operational_limits_enabled && has_operational_limits` | `brandid`, `allowwhenoverlimit`, `checklimittimeoutms` | ✅ | ✅ | ✅ |

---

## 7. Variáveis — Estrutura `brands`

A estrutura do objeto `brands` é **100% idêntica** entre os dois projetos:

```hcl
brands = list(object({
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
```

**Um `terraform.tfvars` existente pode ser migrado sem alteração no bloco `brands`.**

### 7.1 Variáveis novas no `kong-deck` (não afetam Kong)

| Variável | Default | Descrição |
|----------|---------|-----------|
| `deck_namespace` | `"kong"` | Namespace K8s para o Job do decK |
| `deck_image` | `"kong/deck:latest"` | Imagem Docker do decK CLI |
| `argocd_project` | `"default"` | Projeto ArgoCD |
| `argocd_repo_url` | `""` | URL do repositório Git |
| `argocd_target_revision` | `"main"` | Branch/tag para ArgoCD |

---

## 8. Diferenças Arquiteturais (Não-Funcionais)

| Aspecto | Antigo (`kong/`) | Novo (`kong-deck/`) | Impacto em Runtime |
|---------|-----------------|---------------------|--------------------|
| **Provider Terraform** | `greut/kong ~> 5.3.0` (API direta) | `hashicorp/local ~> 2.4` (gera YAML) | Nenhum |
| **Método de aplicação** | Terraform aplica direto via Kong Admin API | Terraform gera `kong.yml` → decK sync | Mesmo resultado final |
| **Deployment** | `terraform apply` | Terraform + ArgoCD + K8s Job `deck sync` | GitOps nativo |
| **State management** | Estado Terraform (risco de drift) | Declarativo e idempotente via decK | Melhor resiliência |
| **Protocols nos plugins** | Implícito (Kong default) | Explícito `["grpc","grpcs","http","https"]` | Nenhum (mais explícito) |
| **Formato declarativo** | Não gera artefato intermediário | `output/kong.yml` com `_format_version: "3.0"` | Auditável |

---

## 9. Pré-requisitos para a Migração

### 9.1 Obrigatórios

1. **Kong >= 3.0** — O formato `_format_version: "3.0"` exige Kong 3.x
2. **Plugins custom instalados no Kong** — os seguintes plugins devem estar disponíveis no runtime:
   - `oob-token-introspection`
   - `oob-error-handler`
   - `oob-fapi-interaction-id`
   - `oob-api-event`
   - `oob-mqd-event`
   - `oob-route-block`
   - `oob-ocsp-validator`
   - `oob-kong-consumer-handler`
   - `oob-operational-limits`
   - `oob-kong-custom-metrics`
3. **decK CLI** — compatível com a versão do Kong Admin API
4. **Acesso ao Kong Admin API** — para o `deck sync`

### 9.2 Configuração

1. Copiar o bloco `brands` do `terraform.tfvars` antigo para o novo (sem alterações)
2. Ajustar `argocd_repo_url` para o repositório Git real
3. Configurar credenciais Kong Admin (`kong_admin_uri`, `kong_admin_token`, etc.)

### 9.3 Validação pós-migração

```bash
# 1. Gerar configuração
cd kong-deck && terraform apply

# 2. Validar YAML
deck validate --state output/kong.yml

# 3. Comparar diff (sem aplicar)
KONG_ADMIN_URL=http://kong-admin:8001 ./scripts/deck-local-sync.sh --diff-only

# 4. Aplicar
KONG_ADMIN_URL=http://kong-admin:8001 ./scripts/deck-local-sync.sh
```

---

## 10. Riscos Identificados

| Risco | Severidade | Mitigação |
|-------|-----------|-----------|
| Plugins custom não instalados no Kong | **ALTA** | Verificar `kong.conf` e plugins instalados antes de `deck sync` |
| Versão do Kong < 3.0 | **ALTA** | Confirmar versão via `kong version` ou Admin API |
| decK incompatível com Kong Enterprise | **MÉDIA** | Usar `deck ping` para validar conectividade |
| ArgoCD não configurado | **BAIXA** | O `deck-local-sync.sh` funciona independente do ArgoCD |
| Perda de consumers/credentials não gerenciados | **BAIXA** | decK com `--select-tag` ou `--skip-consumers` |

---

## 11. Conclusão

**A migração de `kong/` para `kong-deck/` é 100% compatível em termos funcionais.** Todas as 283 rotas, 16 services, 5 plugins globais, 6 plugins por serviço e 8 plugins por rota foram fielmente reproduzidos na versão nova com decK declarativo.

A nova arquitetura traz benefícios significativos sem nenhuma perda funcional:
- **GitOps** nativo via ArgoCD
- **Idempotência** — o `kong.yml` é a single source of truth
- **Auditabilidade** — config versionada e inspecionável
- **Resiliência** — sem dependência de Terraform state para o Kong

**Recomendação: prosseguir com a migração.**
