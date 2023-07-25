// Copyright (c) 2022 Avaloq and/or its affiliates.
// Licensed under the MIT License.

variable "account" {
  description = "unique identifier for the oci tenancy"
  type = string
}

variable "organisation" {
  description = "paramater for a client"
  type = object({
    name   = string,
    home   = string,
    admin  = string
  })
}

variable "service" {
  description = "parameter for a service"
  type = object({
    name     = string,
    contract = string,
    owner    = string,
    region   = string,
    budget   = string,
    class    = number,
    stage    = number
  })
}