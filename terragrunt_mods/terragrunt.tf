# A remote_state block is defined in order to a GCS bucket as the remote state source. Each module's remote state file will be stored in a separate subfolder within this GCS bucket. This bucket has been created on your behalf at the start of the lab. 

remote_state {
  backend = "gcs"
 
  config = {
    bucket = "calabs-bucket-1687145612"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-1698-51ad0befc384"
    location = "us-central1"
  }
}

# The generate block is responsible for creating the necessary provider.tf configuration file that each child module will access within this project. The backend "gcs" empty declaration references the remote state source being defined above. Generate a Google provider block for each child folder
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
  backend "gcs" {}
}
provider "google" {
  credentials = "/home/project/.sa_key"
  project = "cal-1698-51ad0befc384"
  region = "us-central1"
}
  EOF
}