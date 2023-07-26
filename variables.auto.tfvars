#____________________________________________________________
#
# Global - Variables
#____________________________________________________________

# Begin Variables
annotations = [
  {
    key   = "orchestrator"
    value = "terraform:easy-aci:v2.1.9"
  }
]
apic_hostname   = "asgard-apic01.rich.ciscolabs.com"
apic_user       = "admin"
apic_version    = "6.0(2h)"
controller_type = "apic"
ndo_hostname    = "odin-nd01.rich.ciscolabs.com"
ndo_domain      = "RICH"
ndo_user        = "tyscott"
ndo_version     = "4.1(2e)"
management_epgs = [
  {
    name = "inband"
    type = "inb"
  },
  {
    name = "ooband"
    type = "oob"
  }
]