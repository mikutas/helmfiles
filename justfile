# https://k3d.io/v5.5.2/usage/exposing_services/
create-cluster:
	k3d cluster create --config k3d-default.yaml

delete-cluster:
	k3d cluster delete --config k3d-default.yaml

argocd-password:
	@kubectl view-secret argocd-initial-admin-secret -n argo-cd --quiet

# https://argoproj.github.io/argo-workflows/access-token/#token-creation
argowf-token:
	@echo "Bearer $(kubectl get secret jenkins.service-account-token -o=jsonpath='{.data.token}' -n argo | base64 --decode)"

apply NAME:
	helmfile -f apps/{{ NAME }}/helmfile.yaml apply

diff NAME:
	helmfile -f apps/{{ NAME }}/helmfile.yaml diff

destroy NAME:
	helmfile -f apps/{{ NAME }}/helmfile.yaml destroy

template NAME:
	helmfile -f apps/{{ NAME }}/helmfile.yaml template
