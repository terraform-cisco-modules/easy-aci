#_______________________________________________________________________
#
# Terraform Required Parameters:
#  - ACI Provider
#    https://registry.terraform.io/providers/CiscoDevNet/aci/latest
#  - MSO Provider
#    https://registry.terraform.io/providers/CiscoDevNet/mso/latest
#  - Utils Provider
#    https://registry.terraform.io/providers/netascode/utils/latest
#_______________________________________________________________________

terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "2.9.0"
    }
    mso = {
      source  = "CiscoDevNet/mso"
      version = "0.11.1"
    }
    utils = {
      source  = "netascode/utils"
      version = "0.2.5"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aci" {
  cert_name   = local.host.certificate_name
  password    = local.host.auth_type == "password" ? var.apic_password : ""
  private_key = local.host.auth_type == "certificate" ? file(var.apic_private_key) : ""
  url         = "https://${local.host.hostname}"
  username = length(compact([local.host.domain])
  ) > 0 ? "apic#${local.host.domain}\\${local.host.username}" : local.host.username
  insecure = true
}

provider "mso" {
  domain   = local.host.domain == "" ? "local" : local.host.domain
  insecure = true
  password = var.ndo_password
  platform = "nd"
  url      = "https://${local.host.hostname}"
  username = local.host.username
}
