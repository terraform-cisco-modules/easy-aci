locals {
  model = yamldecode(data.utils_yaml_merge.model.output)

  global_settings = {
    annotations = flatten([lookup(local.model.global_settings, "annotations", []), [
      {
        key   = "orchestrator"
        value = "terraform:easy-aci:v3.1.5"
      }
    ]])
    controller = merge({
      auth_type        = "password"
      certificate_name = ""
      domain           = ""
      type             = "apic"
      username         = "admin"
      version          = "6.0(4c)"

    }, local.model.global_settings.controller)
    management_epgs = local.model.global_settings.management_epgs
  }
  host = local.global_settings.controller

  #__________________________________________________________________
  #
  # AAEP to EPG Mappings
  #__________________________________________________________________
  global = lookup(lookup(lookup(local.model, "access", {}), "policies", {}), "global", {})
  aaep_to_epgs = {
    for v in lookup(local.global, "attachable_access_entity_profiles", []) : v.name => {
      access_or_native_vlan     = lookup(v, "access_or_native_vlan", 0)
      allowed_vlans             = lookup(v, "allowed_vlans", "")
      instrumentation_immediacy = lookup(v, "instrumentation_immediacy", "on-demand")
      name                      = v.name
    }
  }

  #__________________________________________________________________
  #
  # Tenant Settings Sensitive Variables
  #__________________________________________________________________
  tenant_sensitive = {
    bgp = {
      password = {
        1 = var.bgp_password_1
      }
    }
    nexus_dashboard = {
      aws_secret_key = {
        1 = var.aws_secret_key
      }
      azure_client_secret = {
        1 = var.azure_client_secret
      }
    }
    ospf = {
      authentication_key = {
        1 = var.ospf_key_1
      }
    }
    vrf = {
      snmp_community = {
        1 = var.vrf_snmp_community_1
      }
    }
  }
}
