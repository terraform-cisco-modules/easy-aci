/*_____________________________________________________________________________________________________________________

ACI Provider Settings
_______________________________________________________________________________________________________________________
*/
variable "apic_hostname" {
  default     = "apic.example.com"
  description = "Cisco APIC Hostname"
  type        = string
}

variable "apic_password" {
  default     = "dummydummy"
  description = "Password for User based Authentication."
  sensitive   = true
  type        = string
}

variable "apic_user" {
  default     = "admin"
  description = "Username for User based Authentication."
  type        = string
}

variable "certificate_name" {
  default     = ""
  description = "Cisco ACI Certificate Name for SSL Based Authentication"
  sensitive   = true
  type        = string
}

variable "private_key" {
  default     = ""
  description = "Cisco ACI Private Key for SSL Based Authentication."
  sensitive   = true
  type        = string
}

variable "apic_version" {
  default     = "5.2(4e)"
  description = "The Version of ACI Running in the Environment."
  type        = string
}


/*_____________________________________________________________________________________________________________________

Nexus Dashboard Orchestrator Provider Settings
_______________________________________________________________________________________________________________________
*/
variable "ndo_domain" {
  default     = "local"
  description = "Default is `local`.  Authentication Domain for Nexus Dashboard Orchestrator Authentication.  Only required if the Auhthenciation domain is not local."
  type        = string
}

variable "ndo_hostname" {
  default     = "ndo.example.com"
  description = "Cisco Nexus Dashboard Orchestrator Hostname"
  type        = string
}

variable "ndo_password" {
  default     = "dummydummy"
  description = "Password for Nexus Dashboard Orchestrator Authentication."
  sensitive   = true
  type        = string
}

variable "ndo_user" {
  default     = "admin"
  description = "Username for Nexus Dashboard Orchestrator Authentication."
  type        = string
}

variable "ndo_version" {
  default     = "5.2(1g)"
  description = "The Version of Nexus Dashboard Orchestrator Running in the Environment."
  type        = string
}

/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotation" {
  default     = "orchestrator:terraform"
  description = "Depricated.  Removing from Module."
  type        = string
}

variable "annotations" {
  default = [
    {
      key   = "orchestrator"
      value = "terraform:easy-aci:v2.1.8"
    }
  ]
  description = "The Version of this Script."
  type = list(object(
    {
      key   = string
      value = string
    }
  ))
}

variable "controller_type" {
  default     = "apic"
  description = <<-EOT
    The Type of Controller for this Site.
    - apic
    - ndo
  EOT
  type        = string
}

variable "management_epgs" {
  default = [
    {
      name = "default"
      type = "oob"
    }
  ]
  description = <<-EOT
    The Management EPG's that will be used by the script.
    - name: Name of the EPG
    - type: Type of EPG
      * inb
      * oob
  EOT
  type = list(object(
    {
      name = string
      type = string
    }
  ))
}


/*_____________________________________________________________________________________________________________________

Access > Policies > Global > MCP Instance Policy — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "mcp_instance_key" {
  default     = ""
  description = "The key or password to uniquely identify the MCP packets within this fabric."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Admin > AAA > Authentication: RADIUS — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "radius_key" {
  default     = ""
  description = "RADIUS Key."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password" {
  default     = ""
  description = "RADIUS Monitoring Password."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Admin > AAA > Authentication: TACACS+ — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "tacacs_key" {
  default     = ""
  description = "TACACS Key."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password" {
  default     = ""
  description = "TACACS Monitoring Password."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Admin > External Data Collectors > Monitoring Destinations > Smart CallHome: {policy_name} — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "smtp_password" {
  default     = ""
  description = "Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Admin > Import/Export > Remote Locations
_______________________________________________________________________________________________________________________
*/
variable "remote_password" {
  default     = ""
  description = "Remote Host Password."
  sensitive   = true
  type        = string
}

variable "ssh_key_contents" {
  default     = ""
  description = "SSH Private Key Based Authentication Contents."
  sensitive   = true
  type        = string
}

variable "ssh_key_passphrase" {
  default     = ""
  description = "SSH Private Key Based Authentication Passphrase."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Fabric > Policies > Pod > Management Access: default - Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "apic_certificate_1" {
  default     = "blah.txt"
  description = "APIC Certificate 1."
  sensitive   = true
  type        = string
}

variable "apic_certificate_2" {
  default     = "blah.txt"
  description = "APIC Certificate 2."
  sensitive   = true
  type        = string
}

variable "apic_intermediate_plus_root_ca_1" {
  default     = "blah.txt"
  description = "Intermediate and Root CA Certificate 1."
  sensitive   = true
  type        = string
}

variable "apic_intermediate_plus_root_ca_2" {
  default     = "blah.txt"
  description = "Intermediate and Root CA Certificate 2."
  sensitive   = true
  type        = string
}

variable "apic_private_key_1" {
  default     = "blah.txt"
  description = "APIC Private Key 1."
  sensitive   = true
  type        = string
}

variable "apic_private_key_2" {
  default     = "blah.txt"
  description = "APIC Private Key 2."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Fabric > Policies > Pod > Date and Time - Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "ntp_key_1" {
  default     = ""
  description = "Key Assigned to NTP id 1."
  sensitive   = true
  type        = string
}

variable "ntp_key_2" {
  default     = ""
  description = "Key Assigned to NTP id 2."
  sensitive   = true
  type        = string
}

variable "ntp_key_3" {
  default     = ""
  description = "Key Assigned to NTP id 3."
  sensitive   = true
  type        = string
}

variable "ntp_key_4" {
  default     = ""
  description = "Key Assigned to NTP id 4."
  sensitive   = true
  type        = string
}

variable "ntp_key_5" {
  default     = ""
  description = "Key Assigned to NTP id 5."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Fabric > Policies > Pod > SNMP  — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "snmp_authorization_key_1" {
  default     = ""
  description = "SNMP Authorization Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_2" {
  default     = ""
  description = "SNMP Authorization Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_3" {
  default     = ""
  description = "SNMP Authorization Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_4" {
  default     = ""
  description = "SNMP Authorization Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_5" {
  default     = ""
  description = "SNMP Authorization Key 5."
  sensitive   = true
  type        = string
}

variable "snmp_community_1" {
  default     = ""
  description = "SNMP Community 1."
  sensitive   = true
  type        = string
}

variable "snmp_community_2" {
  default     = ""
  description = "SNMP Community 2."
  sensitive   = true
  type        = string
}

variable "snmp_community_3" {
  default     = ""
  description = "SNMP Community 3."
  sensitive   = true
  type        = string
}

variable "snmp_community_4" {
  default     = ""
  description = "SNMP Community 4."
  sensitive   = true
  type        = string
}

variable "snmp_community_5" {
  default     = ""
  description = "SNMP Community 5."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_1" {
  default     = ""
  description = "SNMP Privacy Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_2" {
  default     = ""
  description = "SNMP Privacy Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_3" {
  default     = ""
  description = "SNMP Privacy Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_4" {
  default     = ""
  description = "SNMP Privacy Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_5" {
  default     = ""
  description = "SNMP Privacy Key 5."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

System > System Settings: Global AES Encryption Setting — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "aes_passphrase" {
  default     = ""
  description = "Global AES Passphrase."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Virtual Networking > {switch_provider} > {domain_name} > Credentials — Sensitive Variables
_______________________________________________________________________________________________________________________
*/

variable "vmm_password" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Tenants - Nexus Dashboard Orchestrator - Cloud Connector - Sensitive Variables
_______________________________________________________________________________________________________________________
*/

variable "aws_secret_key" {
  default     = ""
  description = "AWS Secret Key Id. It must be provided if the AWS account is not trusted. This parameter will only have effect with vendor = aws."
  sensitive   = true
  type        = string
}

variable "azure_client_secret" {
  default     = "1"
  description = "Azure Client Secret. It must be provided when azure_access_type to credentials. This parameter will only have effect with vendor = azure."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Tenants -> {tenant_name}: Networking -> L3Out -> Logical Node Profile: Routing Protocols - Sensitive Variables
_______________________________________________________________________________________________________________________
*/

variable "bgp_password_1" {
  default     = ""
  description = "BGP Password 1."
  sensitive   = true
  type        = string
}

variable "bgp_password_2" {
  default     = ""
  description = "BGP Password 2."
  sensitive   = true
  type        = string
}

variable "bgp_password_3" {
  default     = ""
  description = "BGP Password 3."
  sensitive   = true
  type        = string
}

variable "bgp_password_4" {
  default     = ""
  description = "BGP Password 4."
  sensitive   = true
  type        = string
}

variable "bgp_password_5" {
  default     = ""
  description = "BGP Password 5."
  sensitive   = true
  type        = string
}

variable "ospf_key_1" {
  default     = ""
  description = "OSPF Key 1."
  sensitive   = true
  type        = string
}

variable "ospf_key_2" {
  default     = ""
  description = "OSPF Key 2."
  sensitive   = true
  type        = string
}

variable "ospf_key_3" {
  default     = ""
  description = "OSPF Key 3."
  sensitive   = true
  type        = string
}

variable "ospf_key_4" {
  default     = ""
  description = "OSPF Key 4."
  sensitive   = true
  type        = string
}

variable "ospf_key_5" {
  default     = ""
  description = "OSPF Key 5."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Tenants -> {tenant_name}: Networking -> VRFs - SNMP Context - Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "vrf_snmp_community_1" {
  default     = ""
  description = "SNMP Community 1."
  sensitive   = true
  type        = string
}

variable "vrf_snmp_community_2" {
  default     = ""
  description = "SNMP Community 2."
  sensitive   = true
  type        = string
}

variable "vrf_snmp_community_3" {
  default     = ""
  description = "SNMP Community 3."
  sensitive   = true
  type        = string
}

variable "vrf_snmp_community_4" {
  default     = ""
  description = "SNMP Community 4."
  sensitive   = true
  type        = string
}

variable "vrf_snmp_community_5" {
  default     = ""
  description = "SNMP Community 5."
  sensitive   = true
  type        = string
}
