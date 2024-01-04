output "resource_group_name" {
  value = azurerm_resource_group.final_task_rg.name
}

output "tls_private_key" {
  value     = tls_private_key.final_task_ssh.private_key_pem
  sensitive = true
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.aks_cluster]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}