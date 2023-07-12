cluster:
	k3d cluster create -p "8081:80@loadbalancer"

destroy:
	k3d cluster delete

argocd:
	helmfile -f helmfile.yaml apply --selector name=argocd

password:
	@kubectl view-secret argocd-initial-admin-secret -n argocd --quiet
