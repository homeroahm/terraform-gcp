# This repostitory contains: 
1. A Dockerfile for running terraform code(*dockerfiles/terraform/*)
2. Terraform code to build GKE infrastructure from Terraformer's remote /modules or Terreform Cloud) .
5. Terraform code to build GKE infrastructure using local VPC and GKE module(*modules/*).
6. Workflow gke_infrastructure_flow.yaml workflow. (GKE Infrastructure)  to automatically deploy our infrastructure from modules/ into GCP.
7. For deploying our realworld-app example to our GKE please follow instructions from: [this repository](https://github.com/homeroahm/react-redux)

# Automatically Deploy Terraform Infrastructure

## Enable the following Google Cloud APIs
```
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com 
gcloud services enable cloudresourcemanager.googleapis.com
```

## Create a Service account
Create a service account with storage.admin role and add it to the /common/bucket/ folder. On google cloud enable the Cloud Storage API.

## Configure Bucket
Configure a GCP Bucket so we can store the state of our infrastructure. Each folder in the terraform structure will have it's own independent state(This helps to encapsulate different parts of our infrastructure).

Clone repository, copy the service account .json credentials here and name it *terraform-sa-key.json*.
If you are using Terraform cloud , copy the Terraform toke finel  (.terraformrc)  to the root folder of the repository

Go to the / folder and run the the terraform commands:
```
docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 init
docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 plan -var-file="<enter your environment>.tfvars"
docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 apply -var-file="<enter your environment>.tfvars"
```
We use our docker image(homeroahm/terraformers:v1) to initialize, plan and apply our terraform infrastructure.

We can either build the infrastructure using local modules or we can build it using the modules from Terraform Cloud Registry.

## Using Terraformers Remote Modules stored in Terraform Cloud
Terraformers Modules for VPC and GKE are automatically updated to the terraform cloud if a change is detected. In this case we need to copy the new versions to our code in the **run-modules** folder.
We use the workflow gke_infrastructure_flow to automatically deploy our infrastructure to out GCP. 
### Secrets
First we need to set up our secrets containing out Docker credentials.
```
GOOGLE_CREDENTIALS -- set your Google Service account token
TF_API_TOKEN     -- set your Terraform Token
```

Now we need to store our GCP credentials in a secret. We need the whole .json file. But first we need to delete any newline, put every string inside quotes and escape double-quotes with double-quotes. e.g. hello = "abc"  ==> ""hello"" = ""abc"".

For removing newlines follow instructions at: https://www.haigmail.com/2019/10/07/setting-up-google_credentials-for-terraform-cloud/.

Then add and escape double-quotes.
```
GOOGLE_CREDENTIALS -- GCP Service Account key .json
```

Finally we need to store our terraform cloud credentials to use terraformers remote VPC and GKE modules. Got to https://app.terraform.io/app/Terraformers21/workspaces and create your credentials. Follow the same steps as for the GCP credentials to format it and store it as a secret.
```
TERRAFORM_CREDENTIAL -- .terraformrc file content
```

### Setting up Github environments
The workflow for deploying the terraform infrastructure contains two environments devevelopment and production. Create these environments for the repository on GitHub and add an approval process for the prod environment.

### Deploy infrastructure
Run the GKE Infrastructure workflow manually. 

Go to your GCP account and the infrastructure should have been deployed. GKE name: gke-ycit-tformers-default-dev in region us-central1.

# Deploying Terraform Infrastructure Manually Instructions
Clone repository to GCP, go to folder run-modules.
Create a folder auth. Copy GCP .json key and terraform .terraformrc file here.

Pull the terraform docker image from the repository. We will run our terraform infrastructure on this image.
Run terraform docker image. **You need to explicitly define the directory with the terraform files when running the terraform container.**
```
docker image pull dpizar/terraformers:v4


docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 init
docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 plan -var-file="<enter your environment here>.tfvars"
docker run --rm -it -v "$(pwd):/terraformfiles" homeroahm/terraformers:v1 apply -var-file="<enter your environment here>.tfvars"// this run the image and initialize our infrastructure under the specified directory.

To Destroy:
docker run --rm -it -v "$(pwd):/terraformfiles" dpizar/terraformers:v1 apply "-destroy" "-auto-approve"
```
