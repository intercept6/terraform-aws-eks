output "kubectl_config" {
  value = "${local.kubeconfig}"
}

output "ConfigMap" {
  value = "${local.eks_configmap}"
}
