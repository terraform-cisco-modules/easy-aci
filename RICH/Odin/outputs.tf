output "aaep_to_epgs" {
  description = "AAEP to EPG Mappings for NDO When it is supported"
  value       = local.aaep_to_epgs
}

output "built_in_tenants" {
  description = "Built-In Tenants module outputs (common|infra|mgmt)."
  value       = module.built_in_tenants
}

output "tenants" {
  description = "Tenants module outputs."
  value       = module.tenants
}
