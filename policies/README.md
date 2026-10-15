# policies

## 元のポリシーとの差分を確認する方法

1. 元のポリシーのリンクが書かれている`kustomization.yaml`の場所を特定する

例: `policies/validate/kustomization.yaml`

2. `kustomization.yaml`から`patches`以下を削除し、適当な場所に保存する

```
yq 'del(.patches)' policies/validate/kustomization.yaml > /tmp/kustomization.yaml
```

3. `patches`を消した / 消してない`kustomize build`結果を適当なツールで比較

```
dyff bw <(kustomize build /tmp) <(kustomize build policies/validate)
```

```
delta <(kustomize build /tmp) <(kustomize build policies/validate)
```
