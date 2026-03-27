# PoC — Kong Gateway + ArgoCD no Kind

Ambiente completo de desenvolvimento local com Kong (modo híbrido) + ArgoCD GitOps.

## Arquitetura do Cluster

```mermaid
graph TB
    subgraph Kind["Kind Cluster"]
        subgraph NS_ARGO["namespace: argocd"]
            ARGO_SRV["ArgoCD Server<br/>:30080 (NodePort)"]
            ARGO_REPO["Repo Server"]
            ARGO_CTRL["Application Controller"]
        end

        subgraph NS_KONG["namespace: kong"]
            PG["PostgreSQL<br/>:5432"]
            CP["Kong CP<br/>Admin :8001<br/>Cluster :8005"]
            DP["Kong DP<br/>Proxy :8000"]
            JOB["decK Sync Job<br/>(PostSync)"]
        end
    end

    subgraph External["Acesso Local"]
        ADMIN["localhost:8001 → Admin API"]
        PROXY["localhost:80 → Proxy"]
        UI["localhost:30080 → ArgoCD UI"]
    end

    PG <--> CP
    CP -.->|"wss (config)"| DP
    JOB -->|"deck sync"| CP
    ARGO_CTRL -->|"sync waves"| NS_KONG

    ADMIN --> CP
    PROXY --> DP
    UI --> ARGO_SRV

    style Kind fill:#e8f4fd
    style NS_ARGO fill:#fff3cd
    style NS_KONG fill:#d4edda
```

## Sync Waves (Ordem de Deploy)

```mermaid
gantt
    title ArgoCD Sync Waves
    dateFormat X
    axisFormat %s

    section Wave 0
    PostgreSQL           :done, 0, 1

    section Wave 1
    Kong Control Plane   :done, 1, 2

    section Wave 2
    Kong Data Plane      :done, 2, 3

    section Wave 3
    decK Sync Job        :done, 3, 4
```

| Wave | Componente | Dependência |
|------|-----------|-------------|
| 0 | PostgreSQL | Nenhuma |
| 1 | Kong CP | PostgreSQL (banco de config) |
| 2 | Kong DP | Kong CP (recebe config via wss) |
| 3 | decK Sync | Kong CP Admin API (aplica config) |

## Estrutura

```
poc/kong/
├── kind-config.yaml          # Config do cluster Kind (port mappings)
├── kong-helm/                 # Setup manual via Helm (start.sh)
│   ├── start.sh              # Gerenciador: install/uninstall/status
│   ├── values-argocd.yaml    # ArgoCD Helm values
│   ├── values-cp.yaml        # Kong CP Helm values
│   ├── values-dp.yaml        # Kong DP Helm values
│   ├── values-pg.yaml        # PostgreSQL Helm values
│   └── certs/                # Certificados TLS (gitignored)
└── kong-gitops/               # Manifests gerenciados pelo ArgoCD
    ├── applications/          # App-of-Apps pattern
    │   ├── kong-root.yaml    # Application raiz
    │   ├── postgres.yaml     # PostgreSQL (wave 0)
    │   ├── kong-cp.yaml      # Kong CP (wave 1)
    │   ├── kong-dp.yaml      # Kong DP (wave 2)
    │   └── kong-deck.yaml    # decK sync (wave 3)
    └── environments/hml/      # Values por ambiente
        ├── global-values.yaml
        ├── kong-cp-values.yaml
        ├── kong-dp-values.yaml
        ├── postgres-values.yaml
        └── deck/              # Kustomize + sync Job
            ├── kustomization.yaml
            ├── kong.yaml.gz
            └── sync-job.yaml
```

## Quick Start

### 1. Criar cluster Kind

```bash
kind create cluster --config kind-config.yaml
```

### 2. Setup manual (Helm)

```bash
cd kong-helm
./start.sh install     # Instala tudo (Kong + ArgoCD)
./start.sh status      # Verifica pods e credenciais
```

### 3. Setup via ArgoCD (GitOps)

```bash
# 1. Instala ArgoCD
./start.sh install-argocd

# 2. Aplica o App-of-Apps root
kubectl apply -f kong-gitops/applications/kong-root.yaml

# 3. ArgoCD gerencia todo o resto automaticamente
```

### 4. Acessar

| Serviço | URL |
|---------|-----|
| Kong Proxy | http://localhost:80 |
| Kong Admin | http://localhost:8001 |
| ArgoCD UI | http://localhost:30080 |

## Dois Modos de Uso

```mermaid
graph LR
    subgraph Manual["Modo Manual (start.sh)"]
        HELM["Helm install"]
        HELM --> KONG_M["Kong rodando"]
    end

    subgraph GitOps["Modo GitOps (ArgoCD)"]
        ROOT["kong-root.yaml"]
        ROOT --> ARGO["ArgoCD"]
        ARGO --> KONG_G["Kong rodando"]
    end

    style Manual fill:#fff3cd
    style GitOps fill:#d4edda
```

- **Manual**: Rápido para testes. `start.sh install` sobe tudo via Helm direto.
- **GitOps**: Produção. ArgoCD gerencia, sincroniza e faz rollback automaticamente.
