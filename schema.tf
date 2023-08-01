// Copyright (c) 2023 Avaloq and/or its affiliates.
// Licensed under the Apache 2.0 license shown at https://www.apache.org/licenses/LICENSE-2.0

// Prepopulated Variables 
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "current_user_ocid" {}

// Compartment Classification
variable "class" {
  type = string
}