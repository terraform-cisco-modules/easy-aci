<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Easy ACI - Comprehensive example for ACI & NDO

There are two examples in this Repository.  The first example is shown in the primary folders:

* `access-policies/`
* `admin/`
* `fabric-policies/`
* `switch/`
* `system_settings/`
* `tenants/`
* `virtual-networking/`

This is to show an example of how the module can be used with a single ACI Fabric.

The more complex example is shown in the `./RICH/` Folder Structure.  This is what is being used for our lab in Richfield Ohio.  In these examples there are four sub-folders.

* `RICH/Asgard` - The First ACI Fabric
* `RICH/Wakanda` - The Second ACI Fabric
* `RICH/Odin` - Nexus Dashboard Orchestrator managing the stretched Tenants Between the two Fabrics
* `RICH/shared_settings` - YAML Data that is the same between Asgard and Wakanda

The Structure of the YAML Files is very flexible.  You can have all the YAML Data in a single file or you can have it in multiple individual folders like is shown in this module.  The important part is that the `data.utils_yaml_merge.model` is configured to read the folders that you put the Data into.  In the single Data Center example the data is read from all the folders in the root path described above (`access-policies`, `admin`, `fabric-policies`, `switch`, `system-settings`, `tenants`, `virtual-networking`).  In comparison, the Asgard and Wakanda Fabrics, read files in their respective home directory plus they shared data found in the `./RICH/shared_settings` folder.

Additionally because the `./RICH/Odin/` Nexus Dashboard Fabric Only supports pushing configuration with the tenants module, currently, only the `built_in_tenants` and `tenants` modules are defined.  The additional function for `Odin` is that it is pulling in the switch_profiles, from both `Asgard` and `Wakanda`, to build `EPG -> Static Path Bindings` in NDO.

### Modify `variables.auto.tfvars` to match environment

`variables.auto.tfvars` contains Terraform variables that I felt fit better outside of the YAML Data Model.  These variables should be configured to be unique to the deployment environment, but examples are shown for the Richfield environemnt in the module.

#### Notes for the `variables.auto.tfvars`

* APIC Attributes: used if the controller_type is `apic`.
* NDO Attributes: used if the controller_type is `ndo`.
* management_epgs: necessary if you are using inband EPG's, and or the ooband EPG is not default.  Both true for our use case.
* annotations: helpful, but not required.  This is used on Tenant Objects that support the annotations attribute.  You can customize this according to anything desired to add, but by default the use case is the version of the easy_aci module is being added.

#### Note 1: Modules can be added or removed dependent on the use case.  The primary example shown is consuming/showing a full environment deployment.  But in the `./RICH/Odin/` example, it is just using the tenant modules.

#### Note 2: The reason for the seperation of `built_in_tenants` vs `tenants` is to make sure objects are always created in common/mgmt first.  So they can be consumed by user tenants or Admin/Fabric etc (management EPGs for example).  If nothing is being configured in common/mgmt/infra the `built_in_tenant` is not necessary.

## YAML Schema Notes for Autocompletion, Help, and Error Validation:

If you would like to enable Autocompletion, Help Context, and Error Validation, (`HIGHLY RECOMMENDED`) perform the following configuration in Visual Studio Code.

### Install the YAML extension by Red Hat
`Extensions`: Search for YAML and Select the 'YAML Language Support by Red Hat'

### Add the YAML Schema's below to the Visual Studio Code Settings

`Settings` » `Settings`: Search for `YAML:Schemas`.

Click: `Edit in settings.json`

Configure the following in `yaml.schemas`
```bash
"https://raw.githubusercontent.com/terraform-cisco-modules/easy-aci-complete/main/yaml_schemas/easy_aci.json": [
    "easy-aci-complete/*/*.yaml",
    "easy-aci-complete/*/*/*/*.yaml"
]
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables

#### At a Minimum for APIC

- Add variable `apic_password` with the value of [your-apic-password] and sensitive set to true

#### At a Minimum for NDO

- Add variable `ndo_password` with the value of [your-ndo-password] and sensitive set to true

#### Add Other Variables as discussed below based on use cases

## [Cloud Posse `tfenv`](https://github.com/cloudposse/tfenv)

Command line utility to transform environment variables for use with Terraform. (e.g. HOSTNAME → TF_VAR_hostname)

Recently I adopted the `tfenv` runner to standardize environment variables with multiple orchestration tools.  tfenv makes it so you don't need to add TF_VAR_ to the variables when you add them to the environment.  But it doesn't work for windows would be the caveat.

In the export examples below, for the Linux Example, the 'TF_VAR_' is excluded because Cloud Posse tfenv is used to insert it during the run.

### Aliases for `.bashrc`

Additionally to Save time on typing commands I use the following aliases by editing the `.bashrc` for my environment.

```bash
alias tfa='tfenv terraform apply main.plan'
alias tfap='tfenv terraform apply -parallelism=1 main.plan'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfp='tfenv terraform plan -out=main.plan'
alias tfu='terraform init -upgrade'
alias tfv='terraform validate'
```

## IMPORTANT: ALL EXAMPLES BELOW ASSUME USING `tfenv` in LINUX

## Minimum Sensitive Variables for ACI

#### Linux

Password Authentication

```bash
export apic_password='<your-apic-password>'
```

Certificate Authentication

```bash
export certificate_name='<your-certificate_name>'
export private_key='<your-private_key>'
```

## Windows

```powershell
$env:TF_VAR_apic_password='<your-apic-password>'
```

## Minimum Sensitive Variables for NDO

#### Linux

```bash
export ndo_password='<your-ndo-password>'
```

#### Windows

```powershell
$env:TF_VAR_ndo_password='<your-ndo-password>'
```

### Sensitive Variables for the Access Module:

* MCP Instance Key: If Desire is to Password Protect MCP traffic.
* VMM Password: vCenter Password for VMM Integration.

#### Linux

```bash
export mcp_instance_key='<mcp_instance_key>'
```
```bash
export vmm_password='<vmm_password>'
```

#### Windows

```bash
$env:TF_VAR_mcp_instance_key='<mcp_instance_key>'
```
```bash
$env:TF_VAR_vmm_password='<vmm_password>'
```

### Sensitive Variables for the Admin Module:

#### Configuration Backup Sensitive Variables

* remote_password: For Password based Authentication.
* ssh_key_contents and ssh_key_passphrase: for SSH Key Based Authentication.

#### Linux

```bash
export remote_password='<remote_password>'
```
```bash
export ssh_key_contents='<ssh_key_contents>'
export ssh_key_passphrase='<ssh_key_passphrase>'
```

#### Windows

```powershell
$env:TF_VAR_remote_password='<remote_password>'
```
```powershell
$env:TF_VAR_ssh_key_contents='<ssh_key_contents>'
$env:TF_VAR_ssh_key_passphrase='<ssh_key_passphrase>'
```

#### RADIUS Sensitive Variables

* radius_key: Key for Protecting RADIUS Server Communication.
* radius_monitoring_password: If Server Monitoring is Enabled, the Password to use with the test user account.

#### Linux

```bash
export radius_key='<radius_key>'
```
```bash
export radius_monitoring_password='<radius_monitoring_password>'
```

#### Windows

```bash
$env:TF_VAR_radius_key='<radius_key>'
```
```bash
$env:TF_VAR_radius_monitoring_password='<radius_monitoring_password>'
```

#### Smart Callhome Sensitive Variables

* smtp_password: Only Required if the SMTP Server Requires Authentication.

#### Linux

```bash
export smtp_password='<smtp_password>'
```

#### Windows

```bash
$env:TF_VAR_smtp_password='<smtp_password>'
```

#### TACACS+ Sensitive Variables

* tacacs_key: Key for Protecting TACACS Server Communication.
* tacacs_monitoring_password: If Server Monitoring is Enabled, the Password to use with the test user account.

#### Linux

```bash
export tacacs_key='<tacacs_key>'
export tacacs_monitoring_password='<tacacs_monitoring_password>'
```

#### Windows

```bash
$env:TF_VAR_tacacs_key='<tacacs_key>'
$env:TF_VAR_tacacs_monitoring_password='<tacacs_monitoring_password>'
```

## Only Showing Linux Examples for the Rest for brevity

### Sensitive Variables for the Fabric Module:

### Note: Multiple Instances.

Note that ntp_key, snmp_authorization, snmp_community, snmp_privacy_key have multiple instances.  This is only in the event you need multiple values for each variable.  If only one value is needed only define one value in the export.

* NTP Authentication Keys

```bash
export ntp_key_1='<ntp_key_1>'
```
```bash
export ntp_key_2='<ntp_key_2>'
```
```bash
export ntp_key_3='<ntp_key_3>'
```
```bash
export ntp_key_4='<ntp_key_4>'
```
```bash
export ntp_key_5='<ntp_key_5>'
```

* SNMP Communities

```bash
export snmp_community_1='<snmp_community_1>'
```
```bash
export snmp_community_2='<snmp_community_2>'
```
```bash
export snmp_community_3='<snmp_community_3>'
```
```bash
export snmp_community_4='<snmp_community_4>'
```
```bash
export snmp_community_5='<snmp_community_5>'
```

* SNMP Authorization Keys and Privacy Keys for SNMP Users

```bash
export snmp_authorization_key_1='<snmp_authorization_key_1>'
```
```bash
export snmp_authorization_key_2='<snmp_authorization_key_2>'
```
```bash
export snmp_authorization_key_3='<snmp_authorization_key_3>'
```
```bash
export snmp_authorization_key_4='<snmp_authorization_key_4>'
```
```bash
export snmp_authorization_key_5='<snmp_authorization_key_5>'
```
```bash
export snmp_privacy_key_1='<snmp_privacy_key_1>'
```
```bash
export snmp_privacy_key_2='<snmp_privacy_key_2>'
```
```bash
export snmp_privacy_key_3='<snmp_privacy_key_3>'
```
```bash
export snmp_privacy_key_4='<snmp_privacy_key_4>'
```
```bash
export snmp_privacy_key_5='<snmp_privacy_key_5>'
```

### Sensitive Variables for the System Settings Module:

Global AES Passphrase Encryption Settings
* aes_passphrase: Used to Encrypt Configuration Backups to protect sensitive attributes.

```bash
export aes_passphrase='<aes_passphrase>'
```

### Sensitive Variables for the Tenants Module:

### NDO Secrets for AWS or Azure Site Authetnication

```bash
export aws_secret_key='<aws_secret_key>'
```

```bash
export azure_client_secret='<azure_client_secret>'
```

### Routing Protocol Authentication

* bgp_password: Only requried for BGP Neighbor Authentication
* ospf_key: Only required for Neighbor Authentication

```bash
export bgp_password_1='<bgp_password_1>'
```
```bash
export bgp_password_2='<bgp_password_2>'
```
```bash
export bgp_password_3='<bgp_password_3>'
```
```bash
export bgp_password_4='<bgp_password_4>'
```
```bash
export bgp_password_5='<bgp_password_5>'
```


```bash
export ospf_key_1='<ospf_key_1>'
```
```bash
export ospf_key_2='<ospf_key_2>'
```
```bash
export ospf_key_3='<ospf_key_3>'
```
```bash
export ospf_key_4='<ospf_key_4>'
```
```bash
export ospf_key_5='<ospf_key_5>'
```


* vrf_snmp_community: Only required if the VRF Should use different Communities than the Global SNMP Values.  These Communities, that need to be added to the SNMP client_groups, will only be usable by the VRF when configured.

```bash
export vrf_snmp_community_1='<vrf_snmp_community_1>'
```
```bash
export vrf_snmp_community_2='<vrf_snmp_community_2>'
```
```bash
export vrf_snmp_community_3='<vrf_snmp_community_3>'
```
```bash
export vrf_snmp_community_4='<vrf_snmp_community_4>'
```
```bash
export vrf_snmp_community_5='<vrf_snmp_community_5>'
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | 2.9.0 |
| <a name="requirement_mso"></a> [mso](#requirement\_mso) | 0.11.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | 0.2.5 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_utils"></a> [utils](#provider\_utils) | 0.2.5 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access"></a> [access](#module\_access) | terraform-cisco-modules/access/aci | 2.1.7 |
| <a name="module_admin"></a> [admin](#module\_admin) | terraform-cisco-modules/admin/aci | 2.1.7 |
| <a name="module_built_in_tenants"></a> [built\_in\_tenants](#module\_built\_in\_tenants) | terraform-cisco-modules/tenants/aci | 2.2.0 |
| <a name="module_fabric"></a> [fabric](#module\_fabric) | terraform-cisco-modules/fabric/aci | 2.1.7 |
| <a name="module_switch"></a> [switch](#module\_switch) | terraform-cisco-modules/switch/aci | 2.1.7 |
| <a name="module_system_settings"></a> [system\_settings](#module\_system\_settings) | terraform-cisco-modules/system-settings/aci | 2.1.7 |
| <a name="module_tenants"></a> [tenants](#module\_tenants) | terraform-cisco-modules/tenants/aci | 2.2.0 |

## NOTE:
**When the Data is merged from the YAML files, it will run through the modules using for_each loop(s).  Sensitive Variables cannot be added to a for_each loop, instead use the variables below to add sensitive values for policies.**

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apic_hostname"></a> [apic\_hostname](#input\_apic\_hostname) | Cisco APIC Hostname | `string` | `"apic.example.com"` | no |
| <a name="input_apic_password"></a> [apic\_password](#input\_apic\_password) | Password for User based Authentication. | `string` | `"dummydummy"` | no |
| <a name="input_apic_user"></a> [apic\_user](#input\_apic\_user) | Username for User based Authentication. | `string` | `"admin"` | no |
| <a name="input_certificate_name"></a> [certificate\_name](#input\_certificate\_name) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(4e)"` | no |
| <a name="input_ndo_domain"></a> [ndo\_domain](#input\_ndo\_domain) | Default is `local`.  Authentication Domain for Nexus Dashboard Orchestrator Authentication.  Only required if the Auhthenciation domain is not local. | `string` | `"local"` | no |
| <a name="input_ndo_hostname"></a> [ndo\_hostname](#input\_ndo\_hostname) | Cisco Nexus Dashboard Orchestrator Hostname | `string` | `"ndo.example.com"` | no |
| <a name="input_ndo_password"></a> [ndo\_password](#input\_ndo\_password) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `"dummydummy"` | no |
| <a name="input_ndo_user"></a> [ndo\_user](#input\_ndo\_user) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_ndo_version"></a> [ndo\_version](#input\_ndo\_version) | The Version of Nexus Dashboard Orchestrator Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | Depricated.  Removing from Module. | `string` | `"orchestrator:terraform"` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The Version of this Script. | <pre>list(object(<br>    {<br>      key   = string<br>      value = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "key": "orchestrator",<br>    "value": "terraform:easy-aci:v2.1.8"<br>  }<br>]</pre> | no |
| <a name="input_controller_type"></a> [controller\_type](#input\_controller\_type) | The Type of Controller for this Site.<br>- apic<br>- ndo | `string` | `"apic"` | no |
| <a name="input_management_epgs"></a> [management\_epgs](#input\_management\_epgs) | The Management EPG's that will be used by the script.<br>- name: Name of the EPG<br>- type: Type of EPG<br>  * inb<br>  * oob | <pre>list(object(<br>    {<br>      name = string<br>      type = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "default",<br>    "type": "oob"<br>  }<br>]</pre> | no |
| <a name="input_mcp_instance_key"></a> [mcp\_instance\_key](#input\_mcp\_instance\_key) | The key or password to uniquely identify the MCP packets within this fabric. | `string` | `""` | no |
| <a name="input_radius_key"></a> [radius\_key](#input\_radius\_key) | RADIUS Key. | `string` | `""` | no |
| <a name="input_radius_monitoring_password"></a> [radius\_monitoring\_password](#input\_radius\_monitoring\_password) | RADIUS Monitoring Password. | `string` | `""` | no |
| <a name="input_tacacs_key"></a> [tacacs\_key](#input\_tacacs\_key) | TACACS Key. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password"></a> [tacacs\_monitoring\_password](#input\_tacacs\_monitoring\_password) | TACACS Monitoring Password. | `string` | `""` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server. | `string` | `""` | no |
| <a name="input_remote_password"></a> [remote\_password](#input\_remote\_password) | Remote Host Password. | `string` | `""` | no |
| <a name="input_ssh_key_contents"></a> [ssh\_key\_contents](#input\_ssh\_key\_contents) | SSH Private Key Based Authentication Contents. | `string` | `""` | no |
| <a name="input_ssh_key_passphrase"></a> [ssh\_key\_passphrase](#input\_ssh\_key\_passphrase) | SSH Private Key Based Authentication Passphrase. | `string` | `""` | no |
| <a name="input_apic_certificate_1"></a> [apic\_certificate\_1](#input\_apic\_certificate\_1) | APIC Certificate 1. | `string` | `"blah.txt"` | no |
| <a name="input_apic_certificate_2"></a> [apic\_certificate\_2](#input\_apic\_certificate\_2) | APIC Certificate 2. | `string` | `"blah.txt"` | no |
| <a name="input_apic_intermediate_plus_root_ca_1"></a> [apic\_intermediate\_plus\_root\_ca\_1](#input\_apic\_intermediate\_plus\_root\_ca\_1) | Intermediate and Root CA Certificate 1. | `string` | `"blah.txt"` | no |
| <a name="input_apic_intermediate_plus_root_ca_2"></a> [apic\_intermediate\_plus\_root\_ca\_2](#input\_apic\_intermediate\_plus\_root\_ca\_2) | Intermediate and Root CA Certificate 2. | `string` | `"blah.txt"` | no |
| <a name="input_apic_private_key_1"></a> [apic\_private\_key\_1](#input\_apic\_private\_key\_1) | APIC Private Key 1. | `string` | `"blah.txt"` | no |
| <a name="input_apic_private_key_2"></a> [apic\_private\_key\_2](#input\_apic\_private\_key\_2) | APIC Private Key 2. | `string` | `"blah.txt"` | no |
| <a name="input_ntp_key_1"></a> [ntp\_key\_1](#input\_ntp\_key\_1) | Key Assigned to NTP id 1. | `string` | `""` | no |
| <a name="input_ntp_key_2"></a> [ntp\_key\_2](#input\_ntp\_key\_2) | Key Assigned to NTP id 2. | `string` | `""` | no |
| <a name="input_ntp_key_3"></a> [ntp\_key\_3](#input\_ntp\_key\_3) | Key Assigned to NTP id 3. | `string` | `""` | no |
| <a name="input_ntp_key_4"></a> [ntp\_key\_4](#input\_ntp\_key\_4) | Key Assigned to NTP id 4. | `string` | `""` | no |
| <a name="input_ntp_key_5"></a> [ntp\_key\_5](#input\_ntp\_key\_5) | Key Assigned to NTP id 5. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_1"></a> [snmp\_authorization\_key\_1](#input\_snmp\_authorization\_key\_1) | SNMP Authorization Key 1. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_2"></a> [snmp\_authorization\_key\_2](#input\_snmp\_authorization\_key\_2) | SNMP Authorization Key 2. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_3"></a> [snmp\_authorization\_key\_3](#input\_snmp\_authorization\_key\_3) | SNMP Authorization Key 3. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_4"></a> [snmp\_authorization\_key\_4](#input\_snmp\_authorization\_key\_4) | SNMP Authorization Key 4. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_5"></a> [snmp\_authorization\_key\_5](#input\_snmp\_authorization\_key\_5) | SNMP Authorization Key 5. | `string` | `""` | no |
| <a name="input_snmp_community_1"></a> [snmp\_community\_1](#input\_snmp\_community\_1) | SNMP Community 1. | `string` | `""` | no |
| <a name="input_snmp_community_2"></a> [snmp\_community\_2](#input\_snmp\_community\_2) | SNMP Community 2. | `string` | `""` | no |
| <a name="input_snmp_community_3"></a> [snmp\_community\_3](#input\_snmp\_community\_3) | SNMP Community 3. | `string` | `""` | no |
| <a name="input_snmp_community_4"></a> [snmp\_community\_4](#input\_snmp\_community\_4) | SNMP Community 4. | `string` | `""` | no |
| <a name="input_snmp_community_5"></a> [snmp\_community\_5](#input\_snmp\_community\_5) | SNMP Community 5. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_1"></a> [snmp\_privacy\_key\_1](#input\_snmp\_privacy\_key\_1) | SNMP Privacy Key 1. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_2"></a> [snmp\_privacy\_key\_2](#input\_snmp\_privacy\_key\_2) | SNMP Privacy Key 2. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_3"></a> [snmp\_privacy\_key\_3](#input\_snmp\_privacy\_key\_3) | SNMP Privacy Key 3. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_4"></a> [snmp\_privacy\_key\_4](#input\_snmp\_privacy\_key\_4) | SNMP Privacy Key 4. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_5"></a> [snmp\_privacy\_key\_5](#input\_snmp\_privacy\_key\_5) | SNMP Privacy Key 5. | `string` | `""` | no |
| <a name="input_aes_passphrase"></a> [aes\_passphrase](#input\_aes\_passphrase) | Global AES Passphrase. | `string` | `""` | no |
| <a name="input_vmm_password"></a> [vmm\_password](#input\_vmm\_password) | Password for VMM Credentials Policy. | `string` | `""` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS Secret Key Id. It must be provided if the AWS account is not trusted. This parameter will only have effect with vendor = aws. | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure Client Secret. It must be provided when azure\_access\_type to credentials. This parameter will only have effect with vendor = azure. | `string` | `"1"` | no |
| <a name="input_bgp_password_1"></a> [bgp\_password\_1](#input\_bgp\_password\_1) | BGP Password 1. | `string` | `""` | no |
| <a name="input_bgp_password_2"></a> [bgp\_password\_2](#input\_bgp\_password\_2) | BGP Password 2. | `string` | `""` | no |
| <a name="input_bgp_password_3"></a> [bgp\_password\_3](#input\_bgp\_password\_3) | BGP Password 3. | `string` | `""` | no |
| <a name="input_bgp_password_4"></a> [bgp\_password\_4](#input\_bgp\_password\_4) | BGP Password 4. | `string` | `""` | no |
| <a name="input_bgp_password_5"></a> [bgp\_password\_5](#input\_bgp\_password\_5) | BGP Password 5. | `string` | `""` | no |
| <a name="input_ospf_key_1"></a> [ospf\_key\_1](#input\_ospf\_key\_1) | OSPF Key 1. | `string` | `""` | no |
| <a name="input_ospf_key_2"></a> [ospf\_key\_2](#input\_ospf\_key\_2) | OSPF Key 2. | `string` | `""` | no |
| <a name="input_ospf_key_3"></a> [ospf\_key\_3](#input\_ospf\_key\_3) | OSPF Key 3. | `string` | `""` | no |
| <a name="input_ospf_key_4"></a> [ospf\_key\_4](#input\_ospf\_key\_4) | OSPF Key 4. | `string` | `""` | no |
| <a name="input_ospf_key_5"></a> [ospf\_key\_5](#input\_ospf\_key\_5) | OSPF Key 5. | `string` | `""` | no |
| <a name="input_vrf_snmp_community_1"></a> [vrf\_snmp\_community\_1](#input\_vrf\_snmp\_community\_1) | SNMP Community 1. | `string` | `""` | no |
| <a name="input_vrf_snmp_community_2"></a> [vrf\_snmp\_community\_2](#input\_vrf\_snmp\_community\_2) | SNMP Community 2. | `string` | `""` | no |
| <a name="input_vrf_snmp_community_3"></a> [vrf\_snmp\_community\_3](#input\_vrf\_snmp\_community\_3) | SNMP Community 3. | `string` | `""` | no |
| <a name="input_vrf_snmp_community_4"></a> [vrf\_snmp\_community\_4](#input\_vrf\_snmp\_community\_4) | SNMP Community 4. | `string` | `""` | no |
| <a name="input_vrf_snmp_community_5"></a> [vrf\_snmp\_community\_5](#input\_vrf\_snmp\_community\_5) | SNMP Community 5. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access"></a> [access](#output\_access) | Access module outputs. |
| <a name="output_admin"></a> [admin](#output\_admin) | Admin module outputs. |
| <a name="output_built_in_tenants"></a> [built\_in\_tenants](#output\_built\_in\_tenants) | Built-In Tenants module outputs (common\|infra\|mgmt). |
| <a name="output_fabric"></a> [fabric](#output\_fabric) | Fabric module outputs. |
| <a name="output_switch"></a> [switch](#output\_switch) | Switch module outputs. |
| <a name="output_system_settings"></a> [system\_settings](#output\_system\_settings) | System Settings module outputs. |
| <a name="output_tenants"></a> [tenants](#output\_tenants) | Tenants module outputs. |

# Sub Modules

If you want to see documentation on Variables for Submodules use the links below:

### [access-policies](https://github.com/terraform-cisco-modules/terraform-aci-access)

### [admin](https://github.com/terraform-cisco-modules/terraform-aci-admin)

### [fabric-policies](https://github.com/terraform-cisco-modules/terraform-aci-fabric)

### [switch](https://github.com/terraform-cisco-modules/terraform-aci-switch)

### [system-settings](https://github.com/terraform-cisco-modules/terraform-aci-system-settings)

### [tenants](https://github.com/terraform-cisco-modules/terraform-aci-tenants)

## Terraform Registry

### [access-policies](https://registry.terraform.io/modules/terraform-cisco-modules/access/aci/latest)

### [admin](https://registry.terraform.io/modules/terraform-cisco-modules/admin/aci/latest)

### [fabric-policies](https://registry.terraform.io/modules/terraform-cisco-modules/fabric/aci/latest)

### [switch](https://registry.terraform.io/modules/terraform-cisco-modules/switch/aci/latest)

### [system-settings](https://registry.terraform.io/modules/terraform-cisco-modules/system-settings/aci/latest)

### [tenants](https://registry.terraform.io/modules/terraform-cisco-modules/tenants/aci/latest)
<!-- END_TF_DOCS -->