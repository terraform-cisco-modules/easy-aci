/*_____________________________________________________________________________________________________________________

ACI/Nexus Dashboard Orchestrator Provider Settings
_______________________________________________________________________________________________________________________
*/
variable "apic_password" {
  default     = "dummydummy"
  description = "Password for User based Authentication."
  sensitive   = true
  type        = string
}

variable "apic_private_key" {
  default     = "blah.txt"
  description = "Cisco ACI Private Key for SSL Based Authentication."
  sensitive   = true
  type        = string
}

variable "ndo_password" {
  default     = "dummydummy"
  description = "Password for Nexus Dashboard Orchestrator Authentication."
  sensitive   = true
  type        = string
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

Admin > AAA > Security: Certificate Authorities/Key Rings - Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "apic_ca_certificate_chain_1" {
  default     = "blah.txt"
  description = "Certificate Authority Certificate Chain.  i.e. Intermediate and Root CA Certificate."
  sensitive   = true
  type        = string
}

variable "apic_ca_certificate_chain_2" {
  default     = "blah.txt"
  description = "Certificate Authority Certificate Chain.  i.e. Intermediate and Root CA Certificate."
  sensitive   = true
  type        = string
}

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

variable "apic_private_key_1" {
  default     = "blah.txt"
  description = "APIC Certificate Private Key 1."
  sensitive   = true
  type        = string
}

variable "apic_private_key_2" {
  default     = "blah.txt"
  description = "APIC Certificate Private Key 2."
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

variable "remote_private_key" {
  default     = "blah.txt"
  description = "SSH Private Key File Location."
  sensitive   = true
  type        = string
}

variable "remote_private_key_passphrase" {
  default     = ""
  description = "SSH Private Key Based Authentication Passphrase."
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

variable "snmp_privacy_key_1" {
  default     = ""
  description = "SNMP Privacy Key 1."
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

variable "ospf_key_1" {
  default     = ""
  description = "OSPF Key 1."
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
