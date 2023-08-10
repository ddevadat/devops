# OCI Provider parameters
variable "api_fingerprint" {
  default     = ""
  description = "Fingerprint of the API private key to use with OCI API."
  type        = string
}

variable "api_private_key_path" {
  default     = ""
  description = "The path to the OCI API private key."
  type        = string
}

variable "istio_regions" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "A map for Istio regions."
  type        = map(string)
}

variable "tenancy_id" {
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
  type        = string
}

variable "user_id" {
  description = "The id of the user that terraform will use to create the resources."
  type        = string
  default     = ""
}

# General OCI parameters
variable "compartment_id" {
  description = "The compartment id where to create all resources."
  type        = string
}

variable "label_prefix" {
  default     = "none"
  description = "A string that will be prepended to all resources."
  type        = string
}


variable "cls1_network_cidrs" {
  type = map(string)

  default = {
    MAIN-VCN-CIDR           = "10.0.0.0/16"
    SUBNET_WORKER_NODE-CIDR = "10.0.1.0/24"
    SUBNET_K8S_API_EP-CIDR  = "10.0.0.0/28"
    SUBNET_LB-CIDR          = "10.0.2.0/24"
    SUBNET_BASTION-CIDR     = "10.0.3.0/24"
    SUBNET_VM-CIDR          = "10.0.4.0/24"
    SUBNET_POD-CIDR         = "10.0.5.0/24"
    ALL-CIDR                = "0.0.0.0/0"
  }
}

variable "cls2_network_cidrs" {
  type = map(string)

  default = {
    MAIN-VCN-CIDR           = "190.0.0.0/16"
    SUBNET_WORKER_NODE-CIDR = "190.0.1.0/24"
    SUBNET_K8S_API_EP-CIDR  = "190.0.0.0/28"
    SUBNET_LB-CIDR          = "190.0.2.0/24"
    SUBNET_BASTION-CIDR     = "190.0.3.0/24"
    SUBNET_VM-CIDR          = "190.0.4.0/24"
    SUBNET_POD-CIDR         = "190.0.5.0/24"
    ALL-CIDR                = "0.0.0.0/0"
  }
}