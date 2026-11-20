# policies

## 元のポリシーとの差分を確認する方法

リポジトリのルートで実行する。

1. 元のポリシーのリンクが書かれている`kustomization.yaml`のあるディレクトリを特定する

例: `policies/validate`

2. ディレクトリごと一時ディレクトリにコピーし、コピー先の`kustomization.yaml`から`patches`以下を削除する

`kustomization.yaml`だけをコピーすると、パッチファイルを相対パスで参照できず、`kustomize build`が失敗する。

```
B=$(mktemp -d) && cp -R policies/validate "$B/validate" && yq -i 'del(.patches)' "$B/validate/kustomization.yaml"
```

3. `patches`を消した / 消してない`kustomize build`結果を適当なツールで比較

```
dyff bw <(kustomize build "$B/validate") <(kustomize build policies/validate)
```

```
delta <(kustomize build "$B/validate") <(kustomize build policies/validate)
```

`kustomize build`は上流のポリシーをネットワーク経由で取得する。`yq`はmikefarah版を使う。

### 特定のポリシーだけに絞る

`policies/validate`は複数のポリシーを含むため、`dyff`の出力を空行区切りの段落ごとにポリシー名で絞る。

```
dyff between --color off --omit-header <(kustomize build "$B/validate") <(kustomize build policies/validate) | awk 'BEGIN{RS="";ORS="\n\n"} /require-pod-probes/'
```
