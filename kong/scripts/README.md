# Scripts de Automação — Kong Deck

Scripts para gerar, validar e aplicar a configuração do Kong.

## Visão Geral

```mermaid
flowchart LR
    subgraph Scripts
        GEN["generate-and-commit.sh"]
        LOCAL["deck-local-sync.sh"]
    end

    subgraph "GitOps (ArgoCD)"
        GEN -->|"--auto-push"| GIT["Git Push"]
        GIT --> ARGO["ArgoCD Sync"]
        ARGO --> JOB["decK Job"]
    end

    subgraph "Local (sem K8s)"
        LOCAL --> KONG["Kong Admin API"]
    end

    TF["terraform apply"] --> GEN
    TF --> LOCAL

    style GEN fill:#50c878,color:#fff
    style LOCAL fill:#f5a623,color:#fff
```

## generate-and-commit.sh

Pipeline completo: Terraform → Validação → GitOps → ArgoCD.

### Uso

```bash
# Gerar kong.yaml apenas
./scripts/generate-and-commit.sh

# Gerar + commit + push (dispara ArgoCD)
./scripts/generate-and-commit.sh --auto-push

# Dry-run (apenas terraform plan)
./scripts/generate-and-commit.sh --dry-run
```

### Fluxo

```mermaid
flowchart TD
    A["terraform init"] --> B["terraform apply"]
    B --> C{"kong.yaml<br/>gerado?"}
    C -->|Não| ERR["❌ Erro"]
    C -->|Sim| D["deck file validate"]
    D --> E["Mostra stats<br/>(YAML vs GZ)"]
    E --> F["Copia .gz → GitOps"]
    F --> G{"--auto-push?"}
    G -->|Sim| H["git add + commit + push"]
    G -->|Não| I["Mostra comando manual"]
    H --> J["✅ ArgoCD sincroniza"]

    style A fill:#4a90d9,color:#fff
    style J fill:#50c878,color:#fff
    style ERR fill:#e74c3c,color:#fff
```

## deck-local-sync.sh

Aplica `kong.yaml` diretamente na Admin API via decK — **sem Kubernetes**.

### Uso

```bash
# Sync interativo (mostra diff e pede confirmação)
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh

# Apenas mostra diff
./scripts/deck-local-sync.sh --diff-only

# Sync sem confirmação (CI/CD)
./scripts/deck-local-sync.sh --yes
```

### Fluxo

```mermaid
flowchart TD
    A["Valida kong.yaml offline"] --> B["Testa conexão Kong API"]
    B --> C{"Modo?"}
    C -->|"--diff-only"| D["deck gateway diff"]
    C -->|"sync"| E["Mostra diff preview"]
    E --> F{"Confirmação?"}
    F -->|Sim| G["deck gateway sync<br/>--parallelism 50"]
    F -->|Não| H["Abortado"]
    G --> I["✅ Sync concluído"]

    style A fill:#4a90d9,color:#fff
    style I fill:#50c878,color:#fff
    style H fill:#f39c12,color:#fff
```

### Variáveis de Ambiente

| Variável | Default | Descrição |
|---|---|---|
| `KONG_ADMIN_URL` | `http://localhost:8001` | URL da Kong Admin API |

## Fluxo GitOps Completo

```
terraform apply → kong.yaml.gz → git push → ArgoCD → Kustomize ConfigMap → PostSync Job → deck gateway sync
```
