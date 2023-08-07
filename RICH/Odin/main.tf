data "utils_yaml_merge" "model" {
  input = concat([
    for file in fileset(path.module, "../Asgard/switches/*.eza.yaml") : file(file)], [
    for file in fileset(path.module, "../Wakanda/switches/*.eza.yaml") : file(file)], [
    for file in fileset(path.module, "*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "*/*eza.yaml") : file(file)]
  )
}

#__________________________________________________________________
#
# BUILT-IN TENANTS MODULE
#__________________________________________________________________

module "built_in_tenants" {
  source     = "../../../terraform-aci-tenants"
  #source  = "terraform-cisco-modules/tenants/aci"
  #version = "2.5.1"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) > 0
  }
  model = merge(each.value, {
    aaep_to_epgs    = {}
    global_settings = local.global_settings
    switch          = {}
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
  source     = "../../../terraform-aci-tenants"
  #source  = "terraform-cisco-modules/tenants/aci"
  #version = "2.5.1"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) == 0
  }
  model = merge(each.value, {
    aaep_to_epgs    = {}
    global_settings = local.global_settings
    switch          = {}
    templates       = lookup(local.model, "templates", {})
  })
  tenant           = each.key
  tenant_sensitive = local.tenant_sensitive
}
