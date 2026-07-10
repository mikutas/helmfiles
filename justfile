import 'apps/cert-manager/cert-manager/justfile'

create-cluster:
	kind create cluster --config kind-config.yaml
	just sync traefik/traefik

delete-cluster:
	kind delete cluster --name app-1-cluster

# 初回インストール時のみ argo-cd release を先に redisSecretInit 有効化した状態で適用してから、
# CRD(AppProject/Application)を生成する argo-cd-custom-resources release を適用する
argocd-install:
	just sync argo-cd/argo-cd -l name=argo-cd --set redisSecretInit.enabled=true
	just sync argo-cd/argo-cd -l name=argo-cd-custom-resources

argocd-password:
	@kubectl view-secret argocd-initial-admin-secret -n argo-cd --quiet

argocd-login:
    @argocd login argocd.local:80 --sso --insecure --grpc-web --plaintext

# https://argoproj.github.io/argo-workflows/access-token/#token-creation
argowf-token:
	@echo "Bearer $(kubectl get secret jenkins.service-account-token -o=jsonpath='{.data.token}' -n argo | base64 --decode)"

apply NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml apply {{ FLAGS }}

sync NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml sync {{ FLAGS }}

template NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml template {{ FLAGS }}
