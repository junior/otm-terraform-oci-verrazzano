[terraform-oci-oke]: https://github.com/oracle-terraform-modules/terraform-oci-oke
[verrazzano]: https://verrazzano.io

# Installing Verrazzano on Oracle Container Engine for Kubernetes (OKE)

This module automates the installation of [Verrazzano][verrazzano] on top of this [terraform-oci-oke][terraform-oci-oke].

## Quick start

### 1. Creating Providers

You need to create 2 providers:
* 1 provider for the region where your OKE cluster and other resources will be created
* 1 provider for your tenancy's home region. This is required for conducting identity operations. 

> **Note that your home region may not necessarily be the same as the region where you want to create the cluster.**

### 2. Update Terraform values

* Copy or rename the `terraform.tfvars.example` to `terraform.tfvars`

```
cp terraform.tfvars.example terraform.tfvars
```

* Enter or update the values to `terraform.tfvars`:

```
api_fingerprint      = ""
api_private_key_path = ""
verrazzano_regions = {
  home  = "us-phoenix-1"
  v8o   = "ap-sydney-1"
}
tenancy_id = ""
user_id    = ""

# general oci parameters
compartment_id = ""
label_prefix   = "dev"

ssh_private_key_path = "~/.ssh/id_rsa"
ssh_public_key_path = "~/.ssh/id_rsa.pub"
```

### 3. Run Terraform

Run Terraform:

. Run Terraform:

```
terraform init
terraform plan
terraform apply
```