# Deploy — Manifestos Kubernetes

Manifestos para deploy da configuração do Kong via ArgoCD + decK no Kubernetes.

## Arquitetura

```
┌──────────────────────────────────────────────────────┐
│                    ArgoCD                             │
│                                                      │
│  Monitora o repositório Git                          │
│  Detecta mudanças no ConfigMap (hash no nome)        │
│  Aplica manifestos no namespace kong                 │
└──────────────────┬───────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│              Namespace: kong                          │
│                                                      │
│  ┌─────────────────┐  ┌──────────────────────────┐  │
│  │   ConfigMap      │  │   Secret                 │  │
│  │   kong-deck-     │  │   kong-admin-credentials │  │
│  │   config-xxxxx   │  │   (DECK_KONG_ADDR)       │  │
│  └────────┬────────┘  └──────────┬───────────────┘  │
│           │                      │                   │
│           ▼                      ▼                   │
│  ┌────────────────────────────────────────────────┐  │
│  │   Job: deck-sync (PostSync Hook)               │  │
│  │                                                │  │
│  │   1. deck file validate /config/kong.yml       │  │
│  │   2. deck gateway sync /config/kong.yml        │  │
│  └────────────────────────────────────────────────┘  │
│                          │                           │
│                          ▼                           │
│  ┌────────────────────────────────────────────────┐  │
│  │   Kong Admin API (kong-cp-kong-admin:8001)     │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

## Estrutura

```
deploy/
├── README.md              # Este arquivo
├── argocd/
│   └── application.yaml   # ArgoCD Application — monitora Git e sincroniza
└── base/
    ├── kustomization.yaml # Kustomize — gera ConfigMap com hash do conteúdo
    ├── namespace.yaml     # Namespace kong
    ├── serviceaccount.yaml# ServiceAccount para o Job
    ├── secret.yaml        # Credenciais do Kong Admin API
    ├── configmap.yaml     # Placeholder (sobrescrito pelo configMapGenerator)
    └── job.yaml           # Job que executa deck sync (PostSync hook)
```

## Arquivos

### argocd/application.yaml

ArgoCD Application que monitora o diretório `deploy/base` no repositório Git. Configurações:

- **Automated sync** com prune e selfHeal
- **Retry** com backoff exponencial (3 tentativas)
- **ignoreDifferences** para campos dinâmicos do Job (selector, labels)

Para configurar, ajuste:
- `spec.source.repoURL` — URL do seu repositório Git
- `spec.source.targetRevision` — Branch ou tag
- `spec.source.path` — Caminho para `deploy/base` no repo

### base/kustomization.yaml

Usa `configMapGenerator` para criar um ConfigMap com o conteúdo de `output/kong.yml`. O nome do ConfigMap inclui um hash do conteúdo — qualquer mudança no `kong.yml` gera um novo nome, e o ArgoCD detecta como diff.

### base/secret.yaml

Contém a URL da Kong Admin API (`DECK_KONG_ADDR`). Em produção, substitua por:
- [External Secrets Operator](https://external-secrets.io/)
- [Sealed Secrets](https://sealed-secrets.netlify.app/)
- [Vault](https://www.vaultproject.io/)

### base/job.yaml

Job Kubernetes que executa o decK sync:

- **Imagem:** `kong/deck:v1.56.0`
- **Hook:** ArgoCD PostSync — executa após os manifestos serem aplicados
- **Delete policy:** BeforeHookCreation — novo Job a cada sync
- **Segurança:** runAsNonRoot, readOnlyRootFilesystem, drop ALL capabilities
- **Recursos:** 100m-500m CPU, 128Mi-256Mi memória

### base/namespace.yaml

Cria o namespace `kong` se não existir.

### base/serviceaccount.yaml

ServiceAccount `deck-sync-sa` usada pelo Job.

### base/configmap.yaml

Placeholder — o conteúdo real é gerado pelo `configMapGenerator` no kustomization.yaml.

## Primeiro Deploy

```bash
# 1. Ajuste a URL do Kong Admin API no secret
vim deploy/base/secret.yaml

# 2. Ajuste a repoURL no ArgoCD application
vim deploy/argocd/application.yaml

# 3. Aplique a Application no ArgoCD
kubectl apply -f deploy/argocd/application.yaml

# 4. Gere e commite o kong.yml
./scripts/generate-and-commit.sh --auto-push
```

## ArgoCD CLI

O ArgoCD CLI usa gRPC, que **não funciona com `kubectl port-forward`** (HTTP/2 incompatível). Use o modo `--core`:

```bash
# Mude para o namespace argocd
kubectl config set-context --current --namespace=argocd

# Login em modo core (usa kubectl direto, sem port-forward)
argocd login --core

# Comandos disponíveis
argocd app list --core
argocd app get kong-deck-config --core
argocd app sync kong-deck-config --core
argocd cluster list --core
```

O modo `--core` fala diretamente com a Kubernetes API e não precisa de conectividade com o ArgoCD server.

## Monitoramento

```bash
# Via ArgoCD CLI (core mode)
argocd app get kong-deck-config --core

# Via kubectl
kubectl get application kong-deck-config -n argocd

# Ver Jobs do deck-sync
kubectl get jobs -n kong -l app.kubernetes.io/name=kong-deck

# Ver logs do último Job
kubectl logs -n kong -l app.kubernetes.io/name=kong-deck --tail=50
```
