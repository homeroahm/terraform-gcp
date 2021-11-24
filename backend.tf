#Store State at Terraform Cloud

terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "terraformers21"

        workspaces {
           name = "gke-infra2"
        }
    }
}