data "utils_yaml_merge" "model" {
  input = concat(
    [for file in fileset(path.module, "../Asgard/access-policies/policies.eza.yaml") : file(file)],
    [for file in fileset(path.module, "../Asgard/switches/*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "../shared_settings/*/*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "../Wakanda/access-policies/policies.eza.yaml") : file(file)],
    [for file in fileset(path.module, "../Wakanda/switches/*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "*/*eza.yaml") : file(file)]
  )
  merge_list_items = false
}

#__________________________________________________________________
#
# BUILT-IN TENANTS MODULE
#__________________________________________________________________

module "built_in_tenants" {
  #source = "/home/tyscott/terraform-cisco-modules/terraform-aci-tenants"
  source  = "terraform-cisco-modules/tenants/aci"
  version = "3.1.10"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) > 0
  }
  model = merge(each.value, lookup(local.model, "templates", {}), {
    aaep_to_epgs    = local.aaep_to_epgs
    global_settings = local.global_settings
    switch          = lookup(local.model, "switch", {})
    templates       = lookup(local.model, "templates", {})
  })
  tenant           = each.key
  tenant_sensitive = local.tenant_sensitive
}

#__________________________________________________________________
#
# TENANTS MODULE
#__________________________________________________________________

module "tenants" {
  depends_on = [module.built_in_tenants]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-tenants"
  source  = "terraform-cisco-modules/tenants/aci"
  version = "3.1.10"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) == 0
  }
  model = merge(each.value, lookup(local.model, "templates", {}), {
    aaep_to_epgs    = local.aaep_to_epgs
    global_settings = local.global_settings
    switch          = lookup(local.model, "switch", {})
    templates       = lookup(local.model, "templates", {})
  })
  tenant           = each.key
  tenant_sensitive = local.tenant_sensitive
}
