#__________________________________________________________________
#
# Tenant Settings Sensitive Variables
#__________________________________________________________________

data "utils_yaml_merge" "model" {
  input = concat(
    [for file in fileset(path.module, "../shared_settings/*/*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "../Odin/tenants/*.eza.yaml") : file(file)],
    [for file in fileset(path.module, "*eza.yaml") : file(file)],
    [for file in fileset(path.module, "*/*eza.yaml") : file(file)]
  )
  merge_list_items = false
}

#__________________________________________________________________
#
# ACCESS MODULE
#__________________________________________________________________

module "access" {
  depends_on = [module.system_settings]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-access"
  source  = "terraform-cisco-modules/access/aci"
  version = "3.1.10"
  for_each = { for v in ["default"] : v => v if length(
    lookup(local.model, "access", {})) > 0 || length(lookup(local.model, "virtual_networking", {})) > 0
  }
  access = merge(
    lookup(local.model, "access", {}),
    { global_settings = local.global_settings },
    lookup(local.model, "virtual_networking", {})
  )
  access_sensitive = local.access_sensitive
}

#__________________________________________________________________
#
# ADMIN MODULE
#__________________________________________________________________

module "admin" {
  depends_on = [module.built_in_tenants]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-admin"
  source          = "terraform-cisco-modules/admin/aci"
  version         = "3.1.10"
  for_each        = { for v in ["default"] : v => v if length(lookup(local.model, "admin", {})) > 0 }
  admin           = merge(lookup(local.model, "admin", {}), { global_settings = local.global_settings })
  admin_sensitive = local.admin_sensitive
}

#__________________________________________________________________
#
# BUILT-IN TENANTS MODULE
#__________________________________________________________________

module "built_in_tenants" {
  depends_on = [module.access]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-tenants"
  source  = "terraform-cisco-modules/tenants/aci"
  version = "3.1.10"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) > 0
  }
  model = merge(each.value, {
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
# FABRIC MODULE
#__________________________________________________________________

module "fabric" {
  depends_on = [module.built_in_tenants]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-fabric/"
  source           = "terraform-cisco-modules/fabric/aci"
  version          = "3.1.10"
  for_each         = { for v in ["default"] : v => v if length(lookup(local.model, "fabric", {})) > 0 }
  fabric           = merge(local.model.fabric, { global_settings = local.global_settings })
  fabric_sensitive = local.fabric_sensitive
}

#__________________________________________________________________
#
# SWITCH MODULE
#__________________________________________________________________

module "switch" {
  depends_on = [module.built_in_tenants]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-switch"
  source  = "terraform-cisco-modules/switch/aci"
  version = "3.1.10"
  for_each = { for v in ["default"] : v => v if length(
    lookup(local.model, "switch", {})) > 0 && local.global_settings.controller.type == "apic"
  }
  switch = local.model.switch
}

#__________________________________________________________________
#
# SYSTEM SETTINGS MODULE
#__________________________________________________________________

module "system_settings" {
  #source = "/home/tyscott/terraform-cisco-modules/terraform-aci-system-settings"
  source  = "terraform-cisco-modules/system-settings/aci"
  version = "3.1.10"
  for_each = {
    for v in ["default"] : v => v if length(lookup(local.model, "system_settings", {})
  ) > 0 && local.global_settings.controller.type == "apic" }
  system_sensitive = local.system_sensitive
  system_settings  = merge(local.model.system_settings, { global_settings = local.global_settings })
}

#__________________________________________________________________
#
# AAEP to EPG Module
#__________________________________________________________________

module "aaep_to_epgs" {
  depends_on = [module.built_in_tenants]
  #source     = "/home/tyscott/terraform-cisco-modules/terraform-aci-aaep-to-epgs"
  source  = "terraform-cisco-modules/aaep-to-epgs/aci"
  version = "3.1.10"
  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)
    ) == 0 && local.global_settings.controller.type == "apic"
  }
  model = merge(each.value, {
    aaep_to_epgs    = local.aaep_to_epgs
    global_settings = local.global_settings
    templates       = lookup(local.model, "templates", {})
  })
  tenant = each.key
}
