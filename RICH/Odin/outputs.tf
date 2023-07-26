output "built_in_tenants" {
  description = "Built-In Tenants module outputs (common|infra|mgmt)."
  value       = module.built_in_tenants
}

output "tenants" {
  description = "Tenants module outputs."
  value       = module.tenants
}
