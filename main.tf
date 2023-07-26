locals {
  model = yamldecode(data.utils_yaml_merge.model.output)
}

data "utils_yaml_merge" "model" {
  input = concat([
    for file in fileset(path.module, "access-policies/*.yaml") : file(file)], [
    for file in fileset(path.module, "admin/*.yaml") : file(file)], [
    for file in fileset(path.module, "fabric-policies/*.yaml") : file(file)], [
    for file in fileset(path.module, "switches/*.yaml") : file(file)], [
    for file in fileset(path.module, "system-settings/*.yaml") : file(file)], [
    for file in fileset(path.module, "tenants/*.yaml") : file(file)], [
    for file in fileset(path.module, "virtual-networking/*.yaml") : file(file)]
  )
}

module "access" {
  depends_on = [
    module.system_settings
  ]
  #source = "../../../terraform-aci-access"
  source  = "terraform-cisco-modules/access/aci"
  version = "2.1.7"

  for_each = { for v in ["default"] : v => v if length(
    lookup(local.model, "access", {})) > 0 || length(lookup(local.model, "virtual_networking", {})) > 0
  }
  access             = lookup(local.model, "access", {})
  annotations        = var.annotations
  apic_version       = var.apic_version
  controller_type    = var.controller_type
  management_epgs    = var.management_epgs
  virtual_networking = lookup(local.model, "virtual_networking", {})
  # Sensitive Variables for Access Policies
  # MCP Instance Policy
  mcp_instance_key = var.mcp_instance_key
  # VMM Domain Credentials Passwords
  vmm_password = var.vmm_password
}

module "admin" {
  depends_on = [
    module.built_in_tenants
  ]
  #source = "../../../terraform-aci-admin"
  source          = "terraform-cisco-modules/admin/aci"
  version         = "2.1.7"
  for_each        = { for v in ["default"] : v => v if length(lookup(local.model, "admin", {})) > 0 }
  admin           = lookup(local.model, "admin", {})
  annotations     = var.annotations
  management_epgs = var.management_epgs
  # Sensitive Variables for Admin Policies
  # Configuration Backup Sensitive Variables
  remote_password    = var.remote_password
  ssh_key_contents   = var.ssh_key_contents
  ssh_key_passphrase = var.ssh_key_passphrase
  # RADIUS Sensitive Variables
  radius_key                 = var.radius_key
  radius_monitoring_password = var.radius_monitoring_password
  # Smart CallHome - SMTP Password
  smtp_password = var.smtp_password
  # TACACS Sensitive Variables
  tacacs_key                 = var.tacacs_key
  tacacs_monitoring_password = var.tacacs_monitoring_password
}

module "built_in_tenants" {
  depends_on = [
    module.access
  ]
  #source = "../../../terraform-aci-tenants"
  source  = "terraform-cisco-modules/tenants/aci"
  version = "2.2.0"

  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) > 0
  }
  aaep_to_epgs    = length(lookup(local.model, "access", {})) > 0 ? module.access["default"].aaep_to_epgs : {}
  annotations     = var.annotations
  controller_type = var.controller_type
  management_epgs = var.management_epgs
  model           = each.value
  templates       = lookup(local.model, "templates", {})
  tenant          = each.key
  # Sensitive Variables for Tenant Policies
  # AWS Secret Key - NDO
  aws_secret_key = var.aws_secret_key
  # Azure Client Secret - NDO
  azure_client_secret = var.azure_client_secret
  # L3Out Routing Protocol Security
  bgp_password_1 = var.bgp_password_1
  bgp_password_2 = var.bgp_password_2
  bgp_password_3 = var.bgp_password_3
  bgp_password_4 = var.bgp_password_4
  bgp_password_5 = var.bgp_password_5
  ospf_key_1     = var.ospf_key_1
  ospf_key_2     = var.ospf_key_2
  ospf_key_3     = var.ospf_key_3
  ospf_key_4     = var.ospf_key_4
  ospf_key_5     = var.ospf_key_5
  # VRF SNMP Context Communities
  vrf_snmp_community_1 = var.vrf_snmp_community_1
  vrf_snmp_community_2 = var.vrf_snmp_community_2
  vrf_snmp_community_3 = var.vrf_snmp_community_3
  vrf_snmp_community_4 = var.vrf_snmp_community_4
  vrf_snmp_community_5 = var.vrf_snmp_community_5
}

module "fabric" {
  depends_on = [
    module.built_in_tenants
  ]
  #source = "../../../terraform-aci-fabric"
  source          = "terraform-cisco-modules/fabric/aci"
  version         = "2.1.7"
  for_each        = { for v in ["default"] : v => v if length(lookup(local.model, "fabric", {})) > 0 }
  fabric          = lookup(local.model, "fabric", {})
  management_epgs = var.management_epgs
  # Sensitive Variables for Fabric Policies
  # APIC Certificate Sensitive Variables
  apic_certificate_1 = fileexists(var.apic_certificate_1) ? file(var.apic_certificate_1) : ""
  apic_certificate_2 = fileexists(var.apic_certificate_2) ? file(var.apic_certificate_2) : ""
  apic_intermediate_plus_root_ca_1 = fileexists(var.apic_intermediate_plus_root_ca_1
  ) ? file(var.apic_intermediate_plus_root_ca_1) : ""
  apic_intermediate_plus_root_ca_2 = fileexists(var.apic_intermediate_plus_root_ca_2
  ) ? file(var.apic_intermediate_plus_root_ca_2) : ""
  apic_private_key_1 = fileexists(var.apic_private_key_1) ? file(var.apic_private_key_1) : ""
  apic_private_key_2 = fileexists(var.apic_private_key_2) ? file(var.apic_private_key_2) : ""
  # Date and Time/NTP Sensitive Variables
  ntp_key_1 = var.ntp_key_1
  ntp_key_2 = var.ntp_key_2
  ntp_key_3 = var.ntp_key_3
  ntp_key_4 = var.ntp_key_4
  ntp_key_5 = var.ntp_key_5
  # SNMP Sensitive Variables
  snmp_authorization_key_1 = var.snmp_authorization_key_1
  snmp_authorization_key_2 = var.snmp_authorization_key_2
  snmp_authorization_key_3 = var.snmp_authorization_key_3
  snmp_authorization_key_4 = var.snmp_authorization_key_4
  snmp_authorization_key_5 = var.snmp_authorization_key_5
  snmp_community_1         = var.snmp_community_1
  snmp_community_2         = var.snmp_community_2
  snmp_community_3         = var.snmp_community_3
  snmp_community_4         = var.snmp_community_4
  snmp_community_5         = var.snmp_community_5
  snmp_privacy_key_1       = var.snmp_privacy_key_1
  snmp_privacy_key_2       = var.snmp_privacy_key_2
  snmp_privacy_key_3       = var.snmp_privacy_key_3
  snmp_privacy_key_4       = var.snmp_privacy_key_4
  snmp_privacy_key_5       = var.snmp_privacy_key_5
}

module "switch" {
  depends_on = [
    module.built_in_tenants
  ]
  #source = "../../../terraform-aci-switch"
  source  = "terraform-cisco-modules/switch/aci"
  version = "2.1.7"

  for_each     = { for v in ["default"] : v => v if length(lookup(local.model, "switch", {})) > 0 }
  annotations  = var.annotations
  apic_version = var.apic_version
  switch       = lookup(local.model, "switch", {})
}

module "system_settings" {
  #source = "../../../terraform-aci-system-settings"
  source  = "terraform-cisco-modules/system-settings/aci"
  version = "2.1.7"

  for_each        = { for v in ["default"] : v => v if length(lookup(local.model, "system_settings", {})) > 0 }
  annotations     = var.annotations
  apic_version    = var.apic_version
  system_settings = lookup(local.model, "system_settings", {})
  # Global AES Passphrase Encryption Settings
  aes_passphrase = var.aes_passphrase
}

module "tenants" {
  depends_on = [
    module.built_in_tenants
  ]
  #source = "../../../terraform-aci-tenants"
  source  = "terraform-cisco-modules/tenants/aci"
  version = "2.2.0"

  for_each = {
    for v in lookup(local.model, "tenants", []) : v.name => v if length(regexall("^(common|infra|mgmt)$", v.name)) == 0
  }
  aaep_to_epgs    = length(lookup(local.model, "access", {})) > 0 ? module.access["default"].aaep_to_epgs : {}
  annotations     = var.annotations
  controller_type = var.controller_type
  model           = each.value
  templates       = lookup(local.model, "templates", {})
  tenant          = each.key
  # Sensitive Variables for Tenant Policies
  # AWS Secret Key - NDO
  aws_secret_key = var.aws_secret_key
  # Azure Client Secret - NDO
  azure_client_secret = var.azure_client_secret
  # L3Out Routing Protocol Security
  bgp_password_1 = var.bgp_password_1
  bgp_password_2 = var.bgp_password_2
  bgp_password_3 = var.bgp_password_3
  bgp_password_4 = var.bgp_password_4
  bgp_password_5 = var.bgp_password_5
  ospf_key_1     = var.ospf_key_1
  ospf_key_2     = var.ospf_key_2
  ospf_key_3     = var.ospf_key_3
  ospf_key_4     = var.ospf_key_4
  ospf_key_5     = var.ospf_key_5
  # VRF SNMP Context Communities
  vrf_snmp_community_1 = var.vrf_snmp_community_1
  vrf_snmp_community_2 = var.vrf_snmp_community_2
  vrf_snmp_community_3 = var.vrf_snmp_community_3
  vrf_snmp_community_4 = var.vrf_snmp_community_4
  vrf_snmp_community_5 = var.vrf_snmp_community_5
}
