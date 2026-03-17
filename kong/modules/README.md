# Módulos Terraform

Dois módulos que transformam as variáveis de entrada em estruturas declarativas para o Kong.

## deck_brand

Orquestra os serviços de um brand/tenant. Para cada brand, instancia 16 sub-módulos `deck_service` — um para cada grupo de APIs do Open Banking Brasil:

| Sub-módulo | Serviço |
|---|---|
| `status` | API de status |
| `status_maintenance` | API de manutenção/status |
| `consent_payment` | Consentimento de pagamento |
| `consent_data_sharing_v2` | Compartilhamento de dados v2 |
| `consent_data_sharing_v3` | Compartilhamento de dados v3 |
| `consent_credit_portability` | Portabilidade de crédito |
| `consent_oob` | Consentimento OOB |
| `consent_as` | Consentimento Auth Server |
| `financial_data` | Dados financeiros |
| `payment` | Pagamento |
| `payment_oob` | Pagamento OOB |
| `payment_as` | Pagamento Auth Server |
| `open_data` | Dados abertos |
| `auth_server_fapi` | Auth Server FAPI |
| `auth_server_fapi_mtls` | Auth Server FAPI mTLS |
| `auth_server_non_fapi` | Auth Server não-FAPI |

### Arquivos

- **main.tf** — Instanciação dos 16 sub-módulos com variáveis por serviço. Output é uma lista flat de services.
- **routes_defaults.tf** — 283 definições de rotas padrão para todas as APIs do Open Banking Brasil. Cada rota define: `name`, `paths`, `methods`, `strip_path`, `plugins`, `headers`.
- **variables.tf** — Variáveis do brand (hosts, portas, FQDNs, features) e override de rotas por service group.

### Uso

```hcl
module "brand_services" {
  source   = "./modules/deck_brand"
  for_each = local.brands_map

  brand            = each.value
  component_prefix = var.component_prefix
  cors_origins     = var.cors_origins
  # ... demais variáveis
}
```

## deck_service

Módulo core que gera **um** service Kong completo com routes e plugins no formato declarativo do decK.

### O que gera

Para cada service, o módulo produz:

```yaml
services:
  - name: oob-brand1-status
    host: oob-status
    port: 8080
    protocol: http
    plugins:
      - name: cors
      - name: rate-limiting
      - name: oob-fapi-interaction-id
      - name: oob-kong-consumer-handler
      - name: oob-error-handler
      - name: oob-ocsp-validator        # condicional
    routes:
      - name: oob-brand1-status-route-1
        paths: ["/open-banking/brand1/..."]
        methods: ["GET"]
        plugins:
          - name: oob-token-introspection  # condicional
          - name: request-transformer
          - name: oob-api-event            # condicional
          - name: oob-route-block          # condicional
```

### Plugins por escopo

**Service-level:**
- `cors` — Sempre presente
- `rate-limiting` — Limitação por IP
- `oob-fapi-interaction-id` — Header FAPI
- `oob-kong-consumer-handler` — Consumer handler
- `oob-error-handler` — Error handler
- `oob-ocsp-validator` — OCSP (condicional)

**Route-level:**
- `oob-token-introspection` — Token validation (condicional)
- `request-transformer` / `response-transformer` — Headers
- `oob-api-event` — Eventos de API (condicional)
- `oob-mqd-event` — Eventos MQD (condicional)
- `oob-route-block` — Bloqueio regulatório (condicional)
- `http-log` — Log de request/response (condicional)
- `oob-operational-limits` — Limites operacionais (condicional)

### Arquivos

- **main.tf** — Lógica de geração do service, routes e plugins. Usa `locals` para montar as estruturas e `jsondecode(jsonencode(...))` para limpar tipos HCL.
- **variables.tf** — Variáveis de configuração do service (host, port, protocol, routes, plugin configs).
