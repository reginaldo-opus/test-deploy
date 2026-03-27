# Kong Deck — Configuração Declarativa do Kong Gateway

Gera a configuração declarativa do Kong Gateway (`kong.yaml`) usando Terraform e aplica via [decK](https://docs.konghq.com/deck/latest/) com deploy automático pelo ArgoCD.

## Visão Geral

Este projeto substitui a configuração imperativa do Kong (via Terraform provider direto na Admin API) por uma abordagem **declarativa**:

1. **Terraform** gera um arquivo `kong.yaml` com toda a configuração (services, routes, plugins)
2. **Git** versiona o arquivo gerado
3. **ArgoCD** detecta mudanças no repositório e dispara o sync
4. **decK** aplica a configuração no Kong Admin API via Job Kubernetes (PostSync hook)

```
┌─────────────┐     ┌───────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  terraform   │────▶│ kong.yaml │────▶│   git    │────▶│  ArgoCD  │────▶│   decK   │
│   apply      │     │ (output/) │     │  push    │     │  detect  │     │   sync   │
└─────────────┘     └───────────┘     └──────────┘     └──────────┘     └──────────┘
                                                                            │
                                                                            ▼
                                                                     ┌──────────┐
                                                                     │   Kong   │
                                                                     │ Admin API│
                                                                     └──────────┘
```

## Estrutura do Projeto

```
kong-deck/
├── README.md                      # Este arquivo
├── main.tf                        # Terraform principal — monta o kong.yaml
├── variables.tf                   # Variáveis de entrada
├── terraform.tfvars.example       # Exemplo de configuração
├── terraform.tfvars               # Configuração real (gitignored)
│
├── modules/                       # Módulos Terraform
│   ├── README.md
│   ├── deck_brand/                # Orquestra serviços por brand/tenant
│   │   ├── main.tf
│   │   ├── routes_defaults.tf     # 283 rotas padrão (Open Banking Brasil)
│   │   └── variables.tf
│   └── deck_service/              # Gera um service Kong com routes e plugins
│       ├── main.tf
│       └── variables.tf
│
├── poc/                           # Ambiente GitOps completo
│   └── kong/
│       ├── kind-config.yaml       # Config do kind cluster
│       └── kong-gitops/
│           ├── applications/      # ArgoCD Application manifests
│           │   ├── kong-root.yaml # App-of-Apps raiz
│           │   ├── kong-cp.yaml   # Kong Control Plane
│           │   ├── kong-dp.yaml   # Kong Data Plane
│           │   ├── kong-deck.yaml # decK sync (Kustomize)
│           │   └── postgres.yaml  # PostgreSQL
│           └── environments/
│               └── hml/
│                   ├── deck/
│                   │   ├── kustomization.yaml  # Gera ConfigMap kong-deck-state
│                   │   ├── kong.yaml           # Configuração declarativa do Kong
│                   │   └── sync-job.yaml       # Job PostSync (deck gateway sync)
│                   ├── kong-cp-values.yaml
│                   ├── kong-dp-values.yaml
│                   └── postgres-values.yaml
│
├── scripts/                       # Scripts de automação
│   ├── README.md
│   ├── generate-and-commit.sh     # Gera kong.yaml e faz git push
│   └── deck-local-sync.sh        # Aplica localmente via decK
│
├── output/                        # Gerado pelo Terraform
│   └── kong.yaml                  # Configuração declarativa completa
│
└── docs/                          # Documentação adicional
    └── COMPATIBILITY_REPORT.md    # Relatório de compatibilidade com projeto anterior
```

## Pré-requisitos

| Ferramenta | Versão | Para quê |
|---|---|---|
| **Terraform** | >= 1.3 | Gerar o `kong.yaml` |
| **decK** | v1.56.0 | Validar e aplicar a config |
| **kubectl** | >= 1.24 | Aplicar manifests K8s |
| **ArgoCD** | >= 2.5 | GitOps (no cluster) |

## Início Rápido

### 1. Configurar variáveis

```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com os valores do seu ambiente
```

### 2. Gerar kong.yaml

```bash
terraform init
terraform apply
# Arquivo gerado em output/kong.yaml
```

### 3. Validar localmente (opcional)

```bash
deck file validate output/kong.yaml
```

### 4. Testar localmente (sem ArgoCD)

```bash
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh
```

### 5. Deploy via ArgoCD

```bash
# Gera, valida, commita e faz push — ArgoCD sincroniza automaticamente
./scripts/generate-and-commit.sh --auto-push
```

## Como Funciona o Deploy (GitOps)

### Fluxo Completo

```
1. terraform apply                  → Gera output/kong.yaml
2. generate-and-commit.sh           → Copia para GitOps deck/ e faz git push
3. ArgoCD detecta                   → Mudança no kong.yaml = novo hash no ConfigMap
4. Kustomize configMapGenerator     → Gera ConfigMap "kong-deck-state" com kong.yaml
5. PostSync Job (sync-job.yaml)     → Monta ConfigMap como volume, executa deck gateway sync
6. Kong atualizado                  → Services, routes e plugins refletem o YAML
```

O `deck gateway sync` computa um diff entre o estado atual do Kong e o `kong.yaml`, aplicando apenas as mudanças necessárias — sem downtime e sem resetar a configuração existente.

### Rollback

```bash
git revert <commit>
git push
# ArgoCD detecta → restaura o kong.yaml anterior automaticamente
```

## Plugins Customizados

10 plugins OOB utilizados:

| Plugin | Escopo | Função |
|--------|--------|--------|
| `oob-error-handler` | Service | Padroniza respostas de erro |
| `oob-fapi-interaction-id` | Service | Valida/gera x-fapi-interaction-id |
| `oob-token-introspection` | Route | Validação de tokens OAuth2 |
| `oob-api-event` | Route | Publica eventos de API |
| `oob-route-block` | Route | Bloqueio de rotas por data regulatória |
| `oob-mqd-event` | Route | Eventos MQD (qualidade de dados) |
| `oob-ocsp-validator` | Service | Validação OCSP de certificados |
| `oob-operational-limits` | Route | Limites operacionais |
| `oob-kong-consumer-handler` | Service | Gerenciamento de consumers |
| `oob-kong-custom-metrics` | Global | Métricas customizadas |

## Multi-Brand / Multi-Tenant

Cada entrada no array `brands` em `terraform.tfvars` gera um conjunto completo de 16 serviços Kong. Para adicionar um brand:

```hcl
brands = [
  { brand_id = "brand1", ... },
  { brand_id = "brand2", ... },  # Novo brand
]
```

## Migração do Projeto Original

| Aspecto | Projeto original (`kong/`) | Este projeto (`kong-deck/`) |
|---|---|---|
| **Provider** | `greut/kong` (HTTP calls) | `hashicorp/local` (gera arquivo) |
| **Output** | Recursos no Kong via API | Arquivo `kong.yaml` declarativo |
| **Aplicação** | Terraform apply direto | decK sync (via Job K8s) |
| **Velocidade** | Centenas de API calls | 1 batch operation |
| **State** | tfstate com recursos Kong | tfstate mínimo (1 arquivo local) |

As **variáveis de entrada são idênticas** — copie seu `terraform.tfvars` do projeto `kong/` e adicione as variáveis do ArgoCD.

Veja [docs/COMPATIBILITY_REPORT.md](docs/COMPATIBILITY_REPORT.md) para a análise completa.

## Troubleshooting

### deck sync falha com "connection refused"

O Job não alcança a Kong Admin API. Verifique:
- O endpoint `kong-cp-kong-admin.kong.svc.cluster.local:8001` está acessível
- O Kong Control Plane (sync-wave: 1) subiu antes do deck job (sync-wave: 3)

### ArgoCD não detecta mudanças

O Kustomize gera ConfigMap com hash do conteúdo. Se `kong.yaml` não mudou, ArgoCD não sincroniza.

### Plugins customizados não encontrados

Os plugins OOB devem estar **instalados no Kong**. O decK apenas configura plugins já disponíveis.

### ArgoCD CLI não conecta (port-forward falha)

O `kubectl port-forward` não suporta gRPC/HTTP2, que o ArgoCD CLI usa. Duas causas comuns:

1. **kubectl desatualizado** — Kubernetes suporta skew de ±1 minor version. Verifique com `kubectl version --client`.
2. **gRPC incompatível com port-forward** — Mesmo com kubectl atualizado, o port-forward pode falhar com gRPC.

**Solução:** Use o modo `--core`, que fala direto com a Kubernetes API sem precisar do ArgoCD server:

```bash
kubectl config set-context --current --namespace=argocd
argocd login --core
argocd app list --core
argocd cluster list --core
```

Todos os comandos `argocd` aceitam a flag `--core`.

## Referências

- [decK Documentation](https://docs.konghq.com/deck/latest/)
- [Kong Declarative Config](https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/)
- [ArgoCD Resource Hooks](https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/)
- [Kustomize ConfigMapGenerator](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/configmapgenerator/)
