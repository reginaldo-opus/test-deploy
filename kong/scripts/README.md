# Scripts de Automação

Scripts para gerar e aplicar a configuração do Kong.

## generate-and-commit.sh

Fluxo completo de CI/CD: gera o `kong.yml` via Terraform, valida com decK e opcionalmente commita e faz push no Git para o ArgoCD detectar.

### Uso

```bash
# Gerar kong.yml apenas (sem commit)
./scripts/generate-and-commit.sh

# Gerar, commitar e fazer push
./scripts/generate-and-commit.sh --auto-push
```

### O que faz

1. `terraform init` — Inicializa providers
2. `terraform apply -auto-approve` — Gera `output/kong.yml`
3. `deck validate` — Valida o YAML offline (se deck disponível)
4. Com `--auto-push`:
   - `git add output/kong.yml deploy/`
   - `git commit` com timestamp
   - `git push`

## deck-local-sync.sh

Aplica o `kong.yml` diretamente no Kong Admin API via decK, **sem Kubernetes nem ArgoCD**. Útil para testes locais.

### Uso

```bash
# Sync completo
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh

# Apenas dump do estado atual (sem aplicar)
KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh --diff-only
```

### O que faz

1. Valida `output/kong.yml` offline
2. Com `--diff-only`: faz dump do estado atual para comparação
3. Sem flag: pede confirmação, executa `deck gateway sync` (computa diff e aplica apenas as mudanças)

### Variáveis de ambiente

| Variável | Default | Descrição |
|---|---|---|
| `KONG_ADMIN_URL` | `http://localhost:8001` | URL da Kong Admin API |
