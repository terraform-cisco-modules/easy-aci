<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Easy ACI - Comprehensive example for ACI & NDO

### YAML Schema for auto-completion, Help, and Error Validation:

If you would like to utilize Autocompletion, Help Context, and Error Validation, `(HIGHLY RECOMMENDED)`, make sure the files all utilize the `.eza.yaml` file extension.

And Add the Following to YAML: Schemas in Visual Studio Code: Settings > Search for YAML: Schema: Click edit in `settings.json`.  In the `yaml.schemas` section:

```bash
"https://raw.githubusercontent.com/terraform-cisco-modules/easy-imm/main/yaml_schema/easy-imm.json": "*.ezi.yaml"
```

Soon the Schema for these YAML Files have been registered with [*SchemaStore*](https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json) via utilizing this `.eza.yaml` file extension.  But until that is complete, need to still add to settings.

## Use Cases

There are two examples in this Repository.  The first example is shown in the primary folders:

* `access-policies/`
* `admin/`
* `fabric-policies/`
* `switch/`
* `system_settings/`
* `tenants/`
* `virtual-networking/`

### IMPORTANT NOTE

Notice the `eza.yaml` extension on the files.  This is how the  `data.utils_yaml_merge.model` is configured to recognize the files that should be imported with the module.

The other examples are shown in the `./RICH/` Folder Structure.  This is what is being used for our lab in Richfield, Ohio.  In these examples there are four sub-folders.

* `RICH/Asgard` - The First ACI Fabric
* `RICH/Wakanda` - The Second ACI Fabric
* `RICH/Odin` - Nexus Dashboard Orchestrator managing the stretched Tenants Between the two Fabrics
* `RICH/shared_settings` - YAML Data that is the same between Asgard and Wakanda

The Structure of the YAML Files is very flexible.  You can have all the YAML Data in a single file or you can have it in multiple individual folders like is shown in this module.  The important part is that the `data.utils_yaml_merge.model` is configured to read the folders that you put the Data into.  In the single Data Center example the data is read from all the folders in the root path described above (`access-policies`, `admin`, `fabric-policies`, `switch`, `system-settings`, `tenants`, `virtual-networking`).  In comparison, the Asgard and Wakanda Fabrics, read files in their respective home directory plus they shared data found in the `./RICH/shared_settings` folder.

Additionally because the `./RICH/Odin/` Nexus Dashboard Fabric Only supports pushing configuration with the tenants module, currently, only the `built_in_tenants` and `tenants` modules are defined.  The additional function for `Odin` is that it is pulling in the switch_profiles, from both `Asgard` and `Wakanda`, to build `EPG -> Static Path Bindings` in NDO.

### Modify `global_settings.eza.yaml` to match environment

`global_settings.eza.yamls` contains variables related to authentication to the controller and an optional global annotations for tagging objects.

#### Notes for the `global_settings.eza.yamls`

* Controller: Defines all the settings for Authentication to an APIC or Nexus Dashboard Orchestrator Controller.
* management_epgs: necessary if you are using inband EPG's, and or the ooband EPG is not default.  Both true for our use case.
* annotations: helpful, but not required.  This is used on Tenant Objects that support the annotations attribute.  You can customize this according to anything desired to add, but by default the use case is the version of the easy_aci module is being added.

#### Note 1: Modules can be added or removed dependent on the use case.  The primary example shown is consuming/showing a full environment deployment.  But in the `./RICH/Odin/` example, it is just using the tenant modules.

#### Note 2: The reason for the seperation of `built_in_tenants` vs `tenants` is to make sure objects are always created in common/mgmt first.  So they can be consumed by user tenants or Admin/Fabric etc (management EPGs for example).  If nothing is being configured in common/mgmt/infra the `built_in_tenant` is not necessary.

## [Cloud Posse `tfenv`](https://github.com/cloudposse/tfenv)

Command line utility to transform environment variables for use with Terraform. (e.g. HOSTNAME → TF_VAR_hostname)

Recently I adopted the `tfenv` runner to standardize environment variables with multiple orchestration tools.  tfenv makes it so you don't need to add TF_VAR_ to the variables when you add them to the environment.  But it doesn't work for windows would be the caveat.

In the export examples below, for the Linux Example, the 'TF_VAR_' is excluded because Cloud Posse tfenv is used to insert it during the run.

### Make sure you have already installed go

## [go](https://go.dev/doc/install)

```bash
go install github.com/cloudposse/tfenv@latest
```

### Add go/bin to PATH

```bash
GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
```

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

## Environment Variables

Note that all the variables in `variables.tf` are marked as sensitive.  Meaning these are variables that shouldn't be exposed due to the sensitive nature of them.

The first three variables are for authentication to either APIC or NDO controllers.  The rest are for configuration parameters in the Fabric.  These sensitive variables are all combined together in `locals.tf` into five objects:

* `access_sensitive`
* `admin_sensitive`
* `fabric_sensitive`
* `system_sensitive`
* `tenant_sensitive`

Using this object structure like this allows for the amount of a single variable to be flexible enough for any environment.  In previous iterations of this repository many of the variables were added with five iterations to cover most use cases, but if more were needed it wasn't possible to add more.  By combining the variables into the object model, you can add or remove variables as needed.

Compare the files `./locals.tf`, `RICH/Asgard/locals.tf`, and `RICH/Odin/locals.tf`.  Notice in the Asgard example most of the variables are taken down to a single iteration, as additional instances are not being consumed.  And with the Odin example, where only the tenant module is utilized, the other iterations of sensitive variables have been removed.

The sensitive variables are still exported as individual variables as I am unsure of a good method of loading the variables into the environment in a better method, but would always appreciate feedback if there is an easy way to build an object model in an export command.

### Terraform Cloud/Enterprise - Workspace Variables

#### At a Minimum for APIC

- Add variable `apic_password` with the value of `<your-apic-password>` and sensitive set to true

#### At a Minimum for Nexus Dashboard Orchestrator

- Add variable `ndo_password` with the value of `<your-ndo-password>` and sensitive set to true

#### Add Other Variables as discussed below based on use cases

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

## Minimum Sensitive Variables for Nexus Dashboard Orchestrator

#### Linux

```bash
export ndo_password='<your-ndo-password>'
```

#### Windows

```powershell
$env:TF_VAR_ndo_password='<your-ndo-password>'
```

### Sensitive Variables for the Access Module:

* MCP Instance Key: Key to Protect MCP traffic.
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
* private_key and private_key_passphrase: for SSH Key Based Authentication.

#### Linux

```bash
export remote_password='<remote_password>'
```
```bash
export private_key='<ssh_key_contents>'
export private_key_passphrase='<ssh_key_passphrase>'
```

#### Windows

```powershell
$env:TF_VAR_remote_password='<remote_password>'
```
```powershell
$env:TF_VAR_private_key='<ssh_key_contents>'
$env:TF_VAR_private_key_passphrase='<ssh_key_passphrase>'
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

* SNMP Communities

```bash
export snmp_community_1='<snmp_community_1>'
```

* SNMP Authorization Keys and Privacy Keys for SNMP Users

```bash
export snmp_authorization_key_1='<snmp_authorization_key_1>'
```
```bash
export snmp_privacy_key_1='<snmp_privacy_key_1>'
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
export ospf_key_1='<ospf_key_1>'
```

* vrf_snmp_community: Only required if the VRF Should use different Communities than the Global SNMP Values.  These Communities, that need to be added to the SNMP client_groups, will only be usable by the VRF when configured.

```bash
export vrf_snmp_community_1='<vrf_snmp_community_1>'
```

## Execute the Terraform Plan

### Terraform Cloud

When running in Terraform Cloud with VCS Integration the first Plan will need to be run from the UI but subsiqent runs should trigger automatically

### Terraform CLI

* Execute the Plan - Linux

```bash
# First time execution requires initialization.  Not needed on subsequent runs.
terraform init
terraform plan -out="main.plan"
terraform apply "main.plan"
```

* Execute the Plan - Windows

```powershell
# First time execution requires initialization.  Not needed on subsequent runs.
terraform.exe init
terraform.exe plan -out="main.plan"
terraform.exe apply "main.plan"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | 2.13.0 |
| <a name="requirement_mso"></a> [mso](#requirement\_mso) | 1.0.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | 0.2.5 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_utils"></a> [utils](#provider\_utils) | 0.2.5 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access"></a> [access](#module\_access) | terraform-cisco-modules/access/aci | 3.1.5 |
| <a name="module_admin"></a> [admin](#module\_admin) | terraform-cisco-modules/admin/aci | 3.1.5 |
| <a name="module_built_in_tenants"></a> [built\_in\_tenants](#module\_built\_in\_tenants) | terraform-cisco-modules/tenants/aci | 3.1.6 |
| <a name="module_fabric"></a> [fabric](#module\_fabric) | terraform-cisco-modules/fabric/aci | 3.1.6 |
| <a name="module_switch"></a> [switch](#module\_switch) | terraform-cisco-modules/switch/aci | 3.1.5 |
| <a name="module_system_settings"></a> [system\_settings](#module\_system\_settings) | terraform-cisco-modules/system-settings/aci | 3.1.5 |
| <a name="module_tenants"></a> [tenants](#module\_tenants) | terraform-cisco-modules/tenants/aci | 3.1.6 |

## NOTE:
**When the Data is merged from the YAML files, it will run through the modules using for_each loop(s).  Sensitive Variables cannot be added to a for_each loop, instead use the variables below to add sensitive values for policies.**

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apic_password"></a> [apic\_password](#input\_apic\_password) | Password for User based Authentication. | `string` | `"dummydummy"` | no |
| <a name="input_apic_private_key"></a> [apic\_private\_key](#input\_apic\_private\_key) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `"blah.txt"` | no |
| <a name="input_ndo_password"></a> [ndo\_password](#input\_ndo\_password) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `"dummydummy"` | no |
| <a name="input_mcp_instance_key"></a> [mcp\_instance\_key](#input\_mcp\_instance\_key) | The key or password to uniquely identify the MCP packets within this fabric. | `string` | `""` | no |
| <a name="input_radius_key"></a> [radius\_key](#input\_radius\_key) | RADIUS Key. | `string` | `""` | no |
| <a name="input_radius_monitoring_password"></a> [radius\_monitoring\_password](#input\_radius\_monitoring\_password) | RADIUS Monitoring Password. | `string` | `""` | no |
| <a name="input_tacacs_key"></a> [tacacs\_key](#input\_tacacs\_key) | TACACS Key. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password"></a> [tacacs\_monitoring\_password](#input\_tacacs\_monitoring\_password) | TACACS Monitoring Password. | `string` | `""` | no |
| <a name="input_apic_ca_certificate_chain_1"></a> [apic\_ca\_certificate\_chain\_1](#input\_apic\_ca\_certificate\_chain\_1) | Certificate Authority Certificate Chain.  i.e. Intermediate and Root CA Certificate. | `string` | `"blah.txt"` | no |
| <a name="input_apic_ca_certificate_chain_2"></a> [apic\_ca\_certificate\_chain\_2](#input\_apic\_ca\_certificate\_chain\_2) | Certificate Authority Certificate Chain.  i.e. Intermediate and Root CA Certificate. | `string` | `"blah.txt"` | no |
| <a name="input_apic_certificate_1"></a> [apic\_certificate\_1](#input\_apic\_certificate\_1) | APIC Certificate 1. | `string` | `"blah.txt"` | no |
| <a name="input_apic_certificate_2"></a> [apic\_certificate\_2](#input\_apic\_certificate\_2) | APIC Certificate 2. | `string` | `"blah.txt"` | no |
| <a name="input_apic_private_key_1"></a> [apic\_private\_key\_1](#input\_apic\_private\_key\_1) | APIC Certificate Private Key 1. | `string` | `"blah.txt"` | no |
| <a name="input_apic_private_key_2"></a> [apic\_private\_key\_2](#input\_apic\_private\_key\_2) | APIC Certificate Private Key 2. | `string` | `"blah.txt"` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server. | `string` | `""` | no |
| <a name="input_remote_password"></a> [remote\_password](#input\_remote\_password) | Remote Host Password. | `string` | `""` | no |
| <a name="input_remote_private_key"></a> [remote\_private\_key](#input\_remote\_private\_key) | SSH Private Key File Location. | `string` | `"blah.txt"` | no |
| <a name="input_remote_private_key_passphrase"></a> [remote\_private\_key\_passphrase](#input\_remote\_private\_key\_passphrase) | SSH Private Key Based Authentication Passphrase. | `string` | `""` | no |
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
| <a name="input_vmm_password"></a> [vmm\_password](#input\_vmm\_password) | Password for VMM Credentials Policy. | `string` | `""` | no |
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

## Terraform Registry

### [*access-policies*](https://registry.terraform.io/modules/terraform-cisco-modules/access/aci/latest)

### [*admin*](https://registry.terraform.io/modules/terraform-cisco-modules/admin/aci/latest)

### [*fabric-policies*](https://registry.terraform.io/modules/terraform-cisco-modules/fabric/aci/latest)

### [*switch*](https://registry.terraform.io/modules/terraform-cisco-modules/switch/aci/latest)

### [*system-settings*](https://registry.terraform.io/modules/terraform-cisco-modules/system-settings/aci/latest)

### [*tenants*](https://registry.terraform.io/modules/terraform-cisco-modules/tenants/aci/latest)
<!-- END_TF_DOCS -->