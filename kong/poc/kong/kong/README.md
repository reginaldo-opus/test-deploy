# Kong Gateway + ArgoCD — Kubernetes Local

Stack para ambiente local com **Kong Gateway** (modo híbrido) e **ArgoCD**, usando Helm.

## Pré-requisitos

- Kubernetes rodando (Docker Desktop, minikube, kind, etc.)
- `kubectl` configurado
- `helm` instalado
- Acesso ao registry de imagens do Kong (ECR)

## Estrutura

```
├── start.sh              # Script principal (install/uninstall/status)
├── values-pg.yaml        # Valores Helm do PostgreSQL
├── values-cp.yaml        # Valores Helm do Kong Control Plane
├── values-dp.yaml        # Valores Helm do Kong Data Plane
├── values-argocd.yaml    # Valores Helm do ArgoCD
├── certs/                # Certificados TLS do cluster Kong (gerados automaticamente)
└── README.md
```

## Instalação

### Instalar tudo (Kong + ArgoCD)

```bash
./start.sh install
```

### Instalar apenas Kong

```bash
./start.sh install-kong
```

### Instalar apenas ArgoCD

```bash
./start.sh install-argocd
```

## Remoção

### Remover tudo

```bash
./start.sh uninstall
```

### Remover apenas Kong

```bash
./start.sh uninstall-kong
```

### Remover apenas ArgoCD

```bash
./start.sh uninstall-argocd
```

## Ver status dos pods

```bash
./start.sh status
```

## Acessando os Serviços

### Kong Admin API

```bash
kubectl port-forward -n kong svc/kong-cp-kong-admin 8001:8001
```
Acesse: `http://localhost:9001`

### Kong Manager (GUI)

```bash
kubectl port-forward -n kong svc/kong-cp-kong-manager 8002:8002
```
Acesse: `http://localhost:8002`

### Kong Proxy

```bash
kubectl port-forward -n kong svc/kong-dp-kong-proxy 9000:80
```
Acesse: `http://localhost:9000`

### ArgoCD UI

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:80
```
Acesse: `http://localhost:8080`

- **Usuário:** `admin`
- **Senha:**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

### ArgoCD CLI

O `kubectl port-forward` não funciona com o ArgoCD CLI (gRPC/HTTP2 incompatível). Use o modo `--core`:

```bash
kubectl config set-context --current --namespace=argocd
argocd login --core
argocd app list --core
argocd cluster list --core
```

## Componentes

| Componente         | Namespace | Descrição                                   |
|--------------------|-----------|----------------------------------------------|
| PostgreSQL         | kong      | Banco de dados do Kong Control Plane         |
| Kong Control Plane | kong      | Gerencia configurações e roteamento          |
| Kong Data Plane    | kong      | Processa o tráfego (proxy)                   |
| ArgoCD             | argocd    | GitOps — deploy contínuo via repositório Git |
