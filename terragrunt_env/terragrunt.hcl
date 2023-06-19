# The directory-level terragrunt.hcl files in each environment will contain the specific configurations to sync it with the root-level terragrunt.hcl file. Each of these directory-level files can be referred to as a child.

# The root-level terragrunt.hcl file acts as your project wrapper and can be referred to as the parent. As you will see later in this lab step, the child terragrunt.hcl files in each environment directory will have a specific pointer to this parent file.

# Remote state location for dev, prod, & qa child folders

remote_state {
  backend = "gcs"
 
  config = {
    bucket = "${var.project_id}-environment"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = var.gcp_credentials
    project = var.project_id
    location = var.region
  }
}
 
# Generate a Google provider block for each child folder
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
}
 
provider "google" {
  credentials = var.gcp_credentials
  project = var.project_id
  region = var.region
}
  EOF
}

# The remote_state block defines the Google Cloud Storage (GCS) configuration for each environment's backend. The config block defines the bucket and the appropriate prefix for each environment. The bucket prefix will organize the remote state files into separate folders named after the environment folders themselves. Once initialized and applied, the lab bucket will contain the following folders:
# - lab-bucket-xxxx/dev/
# - lab-bucket-xxxx/prod/
# - lab-bucket-xxxx/qa/

# Run 
# $ terragrunt run-all init

# A remote_state block is defined in order to a GCS bucket as the remote state source. Each module's remote state file will be stored in a separate subfolder within this GCS bucket. This bucket has been created on your behalf at the start of the lab.
# The generate block is responsible for creating the necessary provider.tf configuration file that each child module will access within this project. The backend "gcs" empty declaration references the remote state source being defined above.