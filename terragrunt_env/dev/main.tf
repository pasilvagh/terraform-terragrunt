# The main.tf file is the standard Terraform configuration file. This file contains the resource configurations to deploy a Google Cloud Platform network and subnetwork.

terraform {
  backend "gcs" {}
}

resource "google_compute_network" "vpc_network_dev" {
  name                    = "vpc_network_dev"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork_dev" {
  name          = "vpc_subnetwork_dev"
  ip_cidr_range = "10.2.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network_dev.id
}