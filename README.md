# terraform-gcp-sympl

This repo contains a Terraform plan for deploying sympl on GCP

## Sympl
Sympl is designed to be easy to use and low maintenance, it is an open-source which is a series of scripts and templates which allow you to automatically and efficiently configure your website and email on a virtual or dedicated Linux server hosting running Debian Stretch or newer.

## Install requirements

### gcloud CLI

In order for Terraform to run operations on your behalf, you must install and configure the gcloud CLI tool. To install the gcloud CLI, follow the [installation guide](https://cloud.google.com/sdk/docs/install) for your system.

After the installation perform the steps outlined below. This will authorize the SDK to access GCP using your user account credentials and add the SDK to your PATH. It requires you to login and select the project you want to work in. Then add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCP.

```bash
gcloud auth application-default login
```

## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >=1.4.6 |
| gcp | >=4.47.0 |

## Providers

|Name | Version |
| --- | ------- |
| gcp | >=4.47.0 |
| null | >=3.2.1 |

## Terraform Resources

| Name | Type |
| ---------| ------------|
| `google_compute_firewall` | Resource |
| `google_compute_address` | Resource |
| `google_compute_instance` | Resource |
| `null_resource` | Resource |

## Inputs

| Name |  Type | Required|
| ---- |  ---- | ------- |
| `project_id` |  string | yes
| `machine_type` | string | yes |
| `region` | string | yes |
| `public_keypath` |  string | yes |
| `private_keypath` | string | yes |

# Usage
`make` automates the process of manually running the terraform command chains

## Configure terraform variables

You may run below command to template out a `terraform.tfvars` file.

```
make setup-gcp
```

## Deploy sympl instance

Once your variables are in place, the terraform plan is set and ready to be applied

```
make create-gcp
```

## Destroy sympl instance

```
make destroy-gcp
```

## Output

| Name | Description |
| ---- | ----------- |
| sympl_password | The password of the user `sympl`. |