# Terraformで作成するEKS

## デプロイ例

### EKSの作成

    terraform plan
    terraform apply -var 'key_name=your_key_name'

### ノードの認識

terraform output の結果をそれぞれファイルに保存する｡

- EKS ConfigMap → manifests/config_map.yml
- kubectl config → .kube/config

    terraform output kubectl_config > .kube/config
    terraform output ConfigMap > manifests/config_map.yml

以下のコマンドを実行する｡

    export KUBECONFIG='.kube/config'
    kubectl apply -f manifests/config_map.yml

ノードがReadyになって居ることを確認する｡

    kubectl get nodes

## 変数

| 変数名         | デフォルト    | 説明                             |
| -------------- | ------------- | -------------------------------- |
| region         | us-west-2     | デプロイ先AWSリージョン          |
| vpc_cidr_block | 10.0.0.0/16   | VPCに割り当てるネットワーク範囲  |
| project        | eks           | プロジェクト名(各リソースで使用) |
| environment    | dev           | 環境名(各リソースで使用)         |
| num_subnets    | 3             | EKSで使用するAZ(サブネット)の数  |
| key_name       | your_key_name | EC2インスタンスに設定する鍵名    |
