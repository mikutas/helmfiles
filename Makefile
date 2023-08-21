# https://k3d.io/v5.4.9/usage/exposing_services/
cluster:
	k3d cluster create -p "8081:80@loadbalancer"

destroy:
	k3d cluster delete

argocd:
	helmfile -f helmfile.yaml apply --selector name=argocd

password:
	@kubectl view-secret argocd-initial-admin-secret -n argocd --quiet

chaos-mesh:
	helmfile -f helmfile.yaml apply --selector name=chaos-mesh
