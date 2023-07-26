#____________________________________________________________
#
# Global - Variables
#____________________________________________________________

# Begin Variables
annotations = [
  {
    key   = "orchestrator"
    value = "terraform:easy-aci:v2.1.7"
  }
]
apic_hostname   = "wakanda-apic01.rich.ciscolabs.com"
apic_user       = "admin"
apic_version    = "6.0(2h)"
controller_type = "apic"
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