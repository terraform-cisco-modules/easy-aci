output "access" {
  description = "Access module outputs."
  value       = module.access
}

output "admin" {
  description = "Admin module outputs."
  value       = module.admin
}

output "built_in_tenants" {
  description = "Built-In Tenants module outputs (common|infra|mgmt)."
  value       = module.built_in_tenants
}

output "fabric" {
  description = "Fabric module outputs."
  value       = module.fabric
}

output "switch" {
  description = "Switch module outputs."
  value       = module.switch
}

output "system_settings" {
  description = "System Settings module outputs."
  value       = module.system_settings
}

output "tenants" {
  description = "Tenants module outputs."
  value       = module.tenants
}
