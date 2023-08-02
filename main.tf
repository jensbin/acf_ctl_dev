// Copyright (c) 2023 Avaloq and/or its affiliates.
// Licensed under the Apache 2.0 license shown at https://www.apache.org/licenses/LICENSE-2.0.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./readme.md

// --- schema --- //
locals {
  components = flatten(compact([
    var.acp == true ? "acp" : "", 
    var.client == true ? "client" : "",  
    var.capi == true ? "capi" : ""
  ]))
}
output "components" {
  value = local.components
}
// --- schema --- //

/*/ --- configuration --- //
module "configuration" {
  source         = "./default/"
  providers = {oci = oci.service}
  account = {
    tenancy_id     = var.tenancy_ocid
    compartment_id = var.compartment_ocid
    home           = var.region
    user_id        = var.current_user_ocid
  }
  resident = {
    topologies = local.topologies
    domains    = local.domains
    segments   = local.segments
  }
  solution = {
    adb          = "${var.adb_type}_${var.adb_size}"
    budget       = var.budget
    class        = var.class
    encrypt      = var.create_wallet
    name         = var.name
    region       = var.location
    organization = var.organization
    osn          = var.osn
    owner        = var.owner
    repository   = var.repository
    stage        = var.stage
    tenancy      = var.tenancy_ocid
    wallet       = var.wallet
  }
}
// --- configuration --- /*/

/*/ --- operation controls --- //
module "resident" {
  source     = "./assets/resident"
  depends_on = [module.configuration]
  providers  = {oci = oci.home}
  schema = {
    # Enable compartment delete on destroy. If true, compartment will be deleted when `terraform destroy` is executed; If false, compartment will not be deleted on `terraform destroy` execution
    enable_delete = var.stage != "PRODUCTION" ? true : false
    # Reference to the deployment root. The service is setup in an encapsulating child compartment 
    parent_id     = var.tenancy_ocid
    user_id       = var.current_user_ocid
  }
  config = {
    tenancy = module.configuration.tenancy
    service = module.configuration.service
  }
}
output "resident" {
  value = {for resource, parameter in module.resident : resource => parameter}
}
// --- operation controls --- //

// --- wallet configuration --- //
module "encryption" {
  source     = "./assets/encryption"
  depends_on = [module.configuration, module.resident]
  providers  = {oci = oci.service}
  for_each   = {for wallet in local.wallets : wallet.name => wallet}
  schema = {
    create = var.create_wallet
    type   = var.wallet == "SOFTWARE" ? "DEFAULT" : "VIRTUAL_PRIVATE"
  }
  config = {
    tenancy    = module.configuration.tenancy
    service    = module.configuration.service
    encryption = module.configuration.encryption[each.key]
  }
  assets = {
    resident   = module.resident
  }
}
output "encryption" {
  value = {for resource, parameter in module.encryption : resource => parameter}
  sensitive = true
}
// --- wallet configuration --- //

// --- network configuration --- //
module "network" {
  source     = "./assets/network"
  depends_on = [module.configuration, module.encryption, module.resident]
  providers = {oci = oci.service}
  for_each  = {for segment in local.segments : segment.name => segment}
  schema = {
    internet = var.internet == "PUBLIC" ? "ENABLE" : "DISABLE"
    nat      = var.nat == true ? "ENABLE" : "DISABLE"
    ipv6     = var.ipv6
    osn      = var.osn
  }
  config = {
    tenancy = module.configuration.tenancy
    service = module.configuration.service
    network = module.configuration.network[each.key]
  }
  assets = {
    encryption = module.encryption["main"]
    resident   = module.resident
  }
}
output "network" {
  value = {for resource, parameter in module.network : resource => parameter}
}
// --- network configuration --- //

// --- database creation --- //
module "database" {
  source     = "./assets/database"
  depends_on = [module.configuration, module.resident, module.network, module.encryption]
  providers  = {oci = oci.service}
  schema = {
    class    = var.class
    create   = var.create_adb
    password = var.create_wallet == false ? "RANDOM" : "VAULT"
  }
  config = {
    tenancy  = module.configuration.tenancy
    service  = module.configuration.service
    database = module.configuration.database
  }
  assets = {
    encryption = module.encryption["main"]
    network    = module.network["core"]
    resident   = module.resident
  }
}
output "database" {
  value = {for resource, parameter in module.database : resource => parameter}
  sensitive = true
}
// --- database creation --- /*/