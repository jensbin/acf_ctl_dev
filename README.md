# Configuration Module

Infrastructure as Code deployment needs elements of configuration data that are be unique and specific to a particular deployment, but generally represents elements of configuration that are used across different implementations. A root configuration module initializes a base set of re-usable topology configuration modules that serve different use case or lifecycle stages. The configuration module create any resources but creates the resources definitions for cloud provider specific provisioning modules, it makes Terraform settings dynamic, taking cloud controller input and dependencies into account to output template configuration data. Some examples of this include:

- Resource naming conventions
- On-premises IP ranges for resource firewalls
- Groups for RBAC roles

In the configuration module these parameter are captured in JSON format and stored in the '/param' directory. The configuration template parase the parameters to create the respecitve resource blocks. Instead of creating configuration scripts per client or per use case we captured the parameter but keep the functional logic, a configuration module.

