# https://k3d.io/v5.5.2/usage/exposing_services/
create-cluster:
	k3d cluster create -p "8081:80@loadbalancer"

delete-cluster:
	k3d cluster delete

argocd-password:
	@kubectl view-secret argocd-initial-admin-secret -n argo-cd --quiet

# https://argoproj.github.io/argo-workflows/access-token/#token-creation
argowf-token:
	@echo "Bearer $(kubectl get secret jenkins.service-account-token -o=jsonpath='{.data.token}' -n argo | base64 --decode)"

apply NAME:
	helmfile -f helmfile.yaml apply --selector name={{ NAME }}

diff NAME:
	helmfile -f helmfile.yaml diff --selector name={{ NAME }}

destroy NAME:
	helmfile -f helmfile.yaml destroy --selector name={{ NAME }}

template NAME:
	helmfile -f helmfile.yaml template --selector name={{ NAME }}
