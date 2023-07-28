// Copyright (c) 2023 Avaloq and/or its affiliates.
// Licensed under the Apache 2.0 license shown at https://www.apache.org/licenses/LICENSE-2.0.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./readme.md

// --- provider settings --- //
terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}
// --- provider settings  --- //

provider "oci" {
  alias  = "service"
  region = var.region
}

provider "oci" {
  alias  = "home"
  region = module.configuration.tenancy.region.key
}

variable "tenancy_ocid" { }

locals {
  topologies = flatten(compact([var.host == true ? "host" : "", var.nodes == true ? "nodes" : "", var.container == true ? "container" : ""]))
  domains    = jsondecode(file("${path.module}/parameter/resident/domains.json"))
  segments   = jsondecode(file("${path.module}/parameter/network/segments.json"))
}

// --- tenancy configuration --- //
module "configuration" {
  source         = "./config/"
  providers = {oci = oci.service}
  oci = {
    tenancy      = var.tenancy_ocid
    class        = var.class
    owner        = var.owner
    organization = var.organization
    solution     = var.solution
    repository   = var.repository
    stage        = var.stage
    region       = var.region
    osn          = var.osn
  }
  resolve = {
    topologies = local.topologies
    domains    = local.domains
    segments   = local.segments
  }
}
// --- tenancy configuration  --- //

/*/ --- operation controls --- //
module "resident" {
  source = "github.com/avaloqcloud/terraform-oci-ocloud-asset-resident"
  depends_on = [module.configuration]
  providers = {oci = oci.home}
  tenancy   = module.configuration.tenancy
  resident  = module.configuration.resident
  input = {
    # Reference to the deployment root. The service is setup in an encapsulating child compartment 
    parent_id     = var.parent
    # Enable compartment delete on destroy. If true, compartment will be deleted when `terraform destroy` is executed; If false, compartment will not be deleted on `terraform destroy` execution
    enable_delete = alltrue([var.stage != "PROD" ? true : false, var.amend])
  }
}
output "resident" {
  value = {
    for resource, parameter in module.resident : resource => parameter
  }
}
// --- operation controls --- /*/

/*/ --- network configuration --- //
module "network" {
  source = "github.com/avaloqcloud/terraform-oci-ocloud-asset-network"
  depends_on = [module.configuration, module.resident]
  providers = {oci = oci.service}
  for_each  = {for segment in local.segments : segment.name => segment}
  tenancy   = module.configuration.tenancy
  resident  = module.configuration.resident
  network   = module.configuration.network[each.key]
  input = {
    internet = var.internet
    nat      = var.nat
    ipv6     = var.ipv6
    osn      = var.osn
  }
  assets = {
    resident = module.resident
  }
}
output "network" {
  value = {
    for resource, parameter in module.network : resource => parameter
    }
}
// --- network configuration --- /*/