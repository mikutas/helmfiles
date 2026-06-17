import 'apps/cert-manager/cert-manager/justfile'

create-cluster:
	kind create cluster --config kind-config.yaml
	just sync traefik/traefik

delete-cluster:
	kind delete cluster --name app-1-cluster

argocd-password:
	@kubectl view-secret argocd-initial-admin-secret -n argo-cd --quiet

# https://argoproj.github.io/argo-workflows/access-token/#token-creation
argowf-token:
	@echo "Bearer $(kubectl get secret jenkins.service-account-token -o=jsonpath='{.data.token}' -n argo | base64 --decode)"

apply NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml apply {{ FLAGS }}

sync NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml sync {{ FLAGS }}

template NAMESPACE_NAME +FLAGS="":
	helmfile -f apps/{{ NAMESPACE_NAME }}/helmfile.yaml template {{ FLAGS }}

argocd-login:
    @argocd login argocd.local:80 --sso --insecure --grpc-web --plaintext
