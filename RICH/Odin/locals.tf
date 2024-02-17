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
