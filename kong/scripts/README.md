# Scripts de Automação

Scripts para gerar e aplicar a configuração do Kong.

## generate-and-commit.sh

Fluxo completo de CI/CD: gera o `kong.yaml` via Terraform, valida com decK, copia para a pasta do GitOps e opcionalmente commita e faz push no Git para o ArgoCD detectar.

### Uso

```bash
# Gerar kong.yaml apenas (sem commit)
./scripts/generate-and-commit.sh

# Gerar, commitar e fazer push
./scripts/generate-and-commit.sh --auto-push
```

### O que faz

1. `terraform init` — Inicializa providers
2. `terraform apply -auto-approve` — Gera `output/kong.yaml`
3. `deck validate` — Valida o YAML offline (se deck disponível)
4. Copia `output/kong.yaml` para `poc/kong/kong-gitops/environments/hml/deck/kong.yaml`
5. Com `--auto-push`:
   - `git add output/kong.yaml poc/kong/kong-gitops/environments/hml/deck/kong.yaml`
   - `git commit` com timestamp
   - `git push`

## deck-local-sync.sh

Aplica o `kong.yaml` diretamente no Kong Admin API via decK, **sem Kubernetes nem ArgoCD**. Útil para testes locais.

### Uso

```bash
# Sync completo
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh

# Apenas dump do estado atual (sem aplicar)
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh --diff-only
```

### O que faz

1. Valida `output/kong.yaml` offline
2. Com `--diff-only`: faz dump do estado atual para comparação
3. Sem flag: pede confirmação, executa `deck gateway sync` (computa diff e aplica apenas as mudanças)

### Variáveis de ambiente

| Variável | Default | Descrição |
|---|---|---|
| `KONG_ADMIN_URL` | `http://localhost:8001` | URL da Kong Admin API |

## Fluxo GitOps (ArgoCD)

O fluxo completo funciona assim:

```
Terraform → output/kong.yaml → git push → ArgoCD detecta → Kustomize gera ConfigMap → Job PostSync → deck gateway sync
```

1. **Terraform** gera `output/kong.yaml`
2. **generate-and-commit.sh** copia para a pasta GitOps e faz push
3. **ArgoCD** detecta a mudança no repo
4. **Kustomize** (via `kustomization.yaml`) gera o ConfigMap `kong-deck-state` a partir do `kong.yaml`
5. **Job PostSync** (`sync-job.yaml`) monta o ConfigMap e executa `deck gateway sync`
