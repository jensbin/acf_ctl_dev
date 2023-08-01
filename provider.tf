// Copyright (c) 2023 Avaloq and/or its affiliates.
// Licensed under the Apache 2.0 license shown at https://www.apache.org/licenses/LICENSE-2.0.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./readme.md

terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
    google = {
      source = "hashicorp/google"
    }
  }
}

/*
provider "oci" {
  alias  = "home"
  region = module.configuration.tenancy.region.key
}

provider "oci" {
  alias  = "service"
  region = var.location
}

provider "google" {
  project = "avc-dev"
  region  = "us-central1"
}
*/