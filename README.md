[//]: # (Copyright (c) 2023 Avaloq and/or its affiliates.)
[//]: # (Licensed under the Apache 2.0 license shown at https://www.apache.org/licenses/LICENSE-2.0.)

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)]
(https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/avaloqcloud/terraform-oci-ocloud-configuration/archive/refs/heads/main.zip)

image::https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg[Deploy on Oracle Cloud, link="https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/avaloqcloud/terraform-oci-ocloud-configuration/archive/refs/heads/main.zip"]

# Avaloq Cloud Framework


The Avaloq Cloud Framework (ACF) supports the adoption of cloud infrastructure with a baseline configuration for a virtual data center. [![License](https://img.shields.io/badge/license-apache-green)](https://www.apache.org/licenses/LICENSE-2.0)

## Development Module

Infrastructure as Code deployment needs elements of configuration data that are be unique and specific to a particular deployment, but generally represents elements of configuration that are used across different implementations. A root configuration module initializes a base set of re-usable topology configuration modules that serve different use case or lifecycle stages. The configuration module create any resources but creates the resources definitions for cloud provider specific provisioning modules, it makes Terraform settings dynamic, taking cloud controller input and dependencies into account to output template configuration data. Some examples of this include:

- Resource naming conventions
- On-premises IP ranges for resource firewalls
- Groups for RBAC roles

In the configuration module these parameter are captured in JSON format and stored in the '/param' directory. The configuration module parses parameters through with the terraform engine to create the resource blocks that inherit use case realted dependencies. Instead of client specific scripts, use case specific parameter is applied to a harmonized logic.
