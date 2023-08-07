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
