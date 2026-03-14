# Kong Deck — Configuração Declarativa do Kong Gateway

Gera a configuração declarativa do Kong Gateway (`kong.yml`) usando Terraform e aplica via [decK](https://docs.konghq.com/deck/latest/) com deploy automático pelo ArgoCD.

## Visão Geral

Este projeto substitui a configuração imperativa do Kong (via Terraform provider direto na Admin API) por uma abordagem **declarativa**:

1. **Terraform** gera um arquivo `kong.yml` com toda a configuração (services, routes, plugins)
2. **Git** versiona o arquivo gerado
3. **ArgoCD** detecta mudanças no repositório e dispara o sync
4. **decK** aplica a configuração no Kong Admin API

```
┌─────────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  terraform   │────▶│ kong.yml  │────▶│   git    │────▶│  ArgoCD  │────▶│   decK   │
│   apply      │     │ (output/) │     │  push    │     │  detect  │     │   sync   │
└─────────────┘     └──────────┘     └──────────┘     └──────────┘     └──────────┘
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
├── main.tf                        # Terraform principal — monta o kong.yml
├── variables.tf                   # Variáveis de entrada
├── terraform.tfvars.example       # Exemplo de configuração
├── terraform.tfvars               # Configuração real (gitignored)
├── .gitignore
├── .terraform.lock.hcl
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
├── deploy/                        # Manifestos Kubernetes para deploy
│   ├── README.md
│   ├── argocd/
│   │   └── application.yaml      # ArgoCD Application manifest
│   └── base/
│       ├── kustomization.yaml     # Kustomize com ConfigMapGenerator
│       ├── namespace.yaml
│       ├── serviceaccount.yaml
│       ├── secret.yaml            # Credenciais do Kong Admin API
│       ├── configmap.yaml         # Placeholder (sobrescrito pelo Kustomize)
│       └── job.yaml               # Job do decK (PostSync hook)
│
├── scripts/                       # Scripts de automação
│   ├── README.md
│   ├── generate-and-commit.sh     # Gera kong.yml e faz git push
│   └── deck-local-sync.sh        # Aplica localmente via decK
│
├── output/                        # Gerado pelo Terraform (gitignored)
│   └── kong.yml                   # Configuração declarativa completa
│
├── docs/                          # Documentação adicional
│   └── COMPATIBILITY_REPORT.md    # Relatório de compatibilidade com projeto anterior
│
└── poc/                           # Ambiente local de desenvolvimento
    └── kong/
        ├── kind-config.yaml       # Config do kind cluster
        └── kong/
            ├── README.md          # Instruções do POC
            ├── start.sh           # Script install/uninstall
            ├── certs/             # Certificados TLS do cluster
            └── values-*.yaml      # Helm values (PostgreSQL, Kong CP/DP, ArgoCD)
```

## Pré-requisitos

| Ferramenta | Versão | Para quê |
|---|---|---|
| **Terraform** | >= 1.3 | Gerar o `kong.yml` |
| **decK** | v1.56.0 | Validar e aplicar a config |
| **kubectl** | >= 1.24 | Aplicar manifests K8s |
| **ArgoCD** | >= 2.5 | GitOps (no cluster) |

## Início Rápido

### 1. Configurar variáveis

```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com os valores do seu ambiente
```

### 2. Gerar kong.yml

```bash
terraform init
terraform apply
# Arquivo gerado em output/kong.yml
```

### 3. Validar localmente (opcional)

```bash
deck file validate output/kong.yml
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

## Como Funciona o Deploy

### Fluxo Completo

```
1. terraform apply        → Gera output/kong.yml
2. git push               → Commita o kong.yml no repositório
3. ArgoCD detecta         → ConfigMap tem hash no nome, mudança = novo hash
4. ArgoCD sync            → Aplica ConfigMap e Job atualizados
5. PostSync Job (decK)    → validate → sync (diff & apply)
6. Kong atualizado        → Services, routes e plugins refletem o YAML
```

O `deck gateway sync` computa um diff entre o estado atual do Kong e o `kong.yml`, aplicando apenas as mudanças necessárias — sem downtime e sem resetar a configuração existente.

### Rollback

```bash
git revert <commit>
git push
# ArgoCD detecta → restaura o kong.yml anterior automaticamente
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
| **Output** | Recursos no Kong via API | Arquivo `kong.yml` declarativo |
| **Aplicação** | Terraform apply direto | decK sync (via Job K8s) |
| **Velocidade** | Centenas de API calls | 1 batch operation |
| **State** | tfstate com recursos Kong | tfstate mínimo (1 arquivo local) |

As **variáveis de entrada são idênticas** — copie seu `terraform.tfvars` do projeto `kong/` e adicione as variáveis do ArgoCD.

Veja [docs/COMPATIBILITY_REPORT.md](docs/COMPATIBILITY_REPORT.md) para a análise completa.

## Troubleshooting

### deck sync falha com "connection refused"

O Job não alcança a Kong Admin API. Verifique:
- O Secret `kong-admin-credentials` tem a URL correta (`deploy/base/secret.yaml`)
- O serviço Kong Admin é acessível no namespace

### ArgoCD não detecta mudanças

O Kustomize gera ConfigMap com hash do conteúdo. Se `kong.yml` não mudou, ArgoCD não sincroniza.

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
