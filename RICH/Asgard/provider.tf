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
  cert_name   = var.certificate_name
  password    = var.apic_password
  private_key = var.private_key
  url         = "https://${var.apic_hostname}"
  username    = var.apic_user
  insecure    = true
}

provider "mso" {
  domain   = var.ndo_domain
  insecure = true
  password = var.ndo_password
  platform = "nd"
  url      = "https://${var.ndo_hostname}"
  username = var.ndo_user
}
