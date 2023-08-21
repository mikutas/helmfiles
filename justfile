# https://k3d.io/v5.5.2/usage/exposing_services/
cluster:
	k3d cluster create -p "8081:80@loadbalancer"

destroy:
	k3d cluster delete

argocd:
	helmfile -f helmfile.yaml apply --selector name=argocd

password:
	@kubectl view-secret argocd-initial-admin-secret -n argocd --quiet

cert-manager:
	helmfile -f helmfile.yaml apply --selector name=cert-manager

chaos-mesh:
	helmfile -f helmfile.yaml apply --selector name=chaos-mesh

goldilocks:
	helmfile -f helmfile.yaml apply --selector name=goldilocks
