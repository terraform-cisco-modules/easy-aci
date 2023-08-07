locals {
  model = yamldecode(data.utils_yaml_merge.model.output)

  global_settings = {
    annotations = flatten([lookup(local.model.global_settings, "annotations", []), [
      {
        key   = "orchestrator"
        value = "terraform:easy-aci:v3.0.1"
      }
    ]])
    controller = merge({
      auth_type        = "password"
      certificate_name = ""
      domain           = ""
      type             = "apic"
      username         = "admin"
      version          = "6.0(2h)"

    }, local.model.global_settings.controller)
    management_epgs = local.model.global_settings.management_epgs
  }
  host = local.global_settings.controller
  #__________________________________________________________________
  #
  # Access Sensitive Variables
  #__________________________________________________________________
  access_sensitive = {
    mcp_instance_policy_default = {
      key = {
        1 = var.mcp_instance_key
      }
    }
    virtual_networking = {
      password = {
        1 = var.vmm_password
      }
    }
  }

  #__________________________________________________________________
  #
  # Admin Sensitive Variables
  #__________________________________________________________________
  admin_sensitive = {
    configuration_backup = {
      password = {
        1 = var.remote_password
      }
      private_key = {
        1 = fileexists(var.remote_private_key) ? file(var.remote_private_key) : ""
        1 = var.remote_private_key
      }
      private_key_passphrase = {
        1 = var.remote_private_key_passphrase
      }
    }
    radius = {
      key = {
        1 = var.radius_key
      }
      password = {
        1 = var.radius_monitoring_password
      }
    }
    security = {
      ca_certificate = {
        1 = fileexists(var.apic_ca_certificate_chain_1) ? file(var.apic_ca_certificate_chain_1) : ""
        2 = fileexists(var.apic_ca_certificate_chain_2) ? file(var.apic_ca_certificate_chain_2) : ""
      }
      certificate = {
        1 = fileexists(var.apic_certificate_1) ? file(var.apic_certificate_1) : ""
        2 = fileexists(var.apic_certificate_2) ? file(var.apic_certificate_2) : ""
      }
      private_key = {
        1 = fileexists(var.apic_private_key_1) ? file(var.apic_private_key_1) : ""
        2 = fileexists(var.apic_private_key_2) ? file(var.apic_private_key_2) : ""
      }
    }
    smart_callhome = {
      password = {
        1 = var.smtp_password
      }
    }
    tacacs = {
      key = {
        1 = var.tacacs_key
      }
      password = {
        1 = var.tacacs_monitoring_password
      }
    }
  }

  #__________________________________________________________________
  #
  # Fabric Sensitive Variables
  #__________________________________________________________________
  fabric_sensitive = {
    ntp = {
      key_id = {
        1 = var.ntp_key_1
        2 = var.ntp_key_2
        3 = var.ntp_key_3
        4 = var.ntp_key_4
        5 = var.ntp_key_5
      }
    }
    snmp = {
      authorization_key = {
        1 = var.snmp_authorization_key_1
        2 = var.snmp_authorization_key_2
        3 = var.snmp_authorization_key_3
        4 = var.snmp_authorization_key_4
        5 = var.snmp_authorization_key_5
      }
      community = {
        1 = var.snmp_community_1
        2 = var.snmp_community_2
        3 = var.snmp_community_3
        4 = var.snmp_community_4
        5 = var.snmp_community_5
      }
      privacy_key = {
        1 = var.snmp_privacy_key_1
        2 = var.snmp_privacy_key_2
        3 = var.snmp_privacy_key_3
        4 = var.snmp_privacy_key_4
        5 = var.snmp_privacy_key_5
      }
    }
  }

  #__________________________________________________________________
  #
  # System Settings Sensitive Variables
  #__________________________________________________________________
  system_sensitive = {
    global_aes_encryption_settings = {
      passphrase = {
        1 = var.aes_passphrase
      }
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
        2 = var.bgp_password_2
        3 = var.bgp_password_3
        4 = var.bgp_password_4
        5 = var.bgp_password_5
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
        2 = var.ospf_key_2
        3 = var.ospf_key_3
        4 = var.ospf_key_4
        5 = var.ospf_key_5
      }
    }
    vrf = {
      snmp_community = {
        1 = var.vrf_snmp_community_1
        2 = var.vrf_snmp_community_2
        3 = var.vrf_snmp_community_3
        4 = var.vrf_snmp_community_4
        5 = var.vrf_snmp_community_5
      }
    }
  }

}
