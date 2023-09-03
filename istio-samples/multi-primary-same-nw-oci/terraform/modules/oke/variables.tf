variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_id" {
  description = "VCN OCID"
}

variable "kubernetes_version" {
  default     = "v1.26.2"
  description = "The version of kubernetes to use when provisioning OKE or to upgrade an existing OKE cluster to."
  type        = string
}

variable "cluster_name" {
  default     = null
  description = "The name of oke cluster."
  type        = string
}

variable "cni_type" {
  default     = "npn"
  description = "The CNI for the cluster: 'flannel' or 'npn'. See <a href=https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpodnetworking.htm>Pod Networking</a>."
  type        = string
  validation {
    condition     = contains(["flannel", "npn"], var.cni_type)
    error_message = "Accepted values are flannel or npn"
  }
}

variable "control_plane_is_public" {
  default     = true
  description = "Whether the Kubernetes control plane endpoint should be allocated a public IP address to enable access over public internet."
  type        = bool
}

variable "control_plane_subnet_id" {
  type = string
}

variable "worker_node_subnet_id" {
  type = string
}

variable "pods_cidr" {
  type = string
}

variable "lb_subnet_id" {
  type = string
}

variable "cluster_type" {
  default     = "BASIC_CLUSTER"
  description = "The cluster type. See <a href=https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengworkingwithenhancedclusters.htm>Working with Enhanced Clusters and Basic Clusters</a> for more information."
  type        = string
  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], (var.cluster_type))
    error_message = "Accepted values are 'BASIC_CLUSTER' or 'BASIC_CLUSTER'."
  }
}


variable "node_pool_name" {
  default     = "pool1"
  description = "Name of the node pool"
}

variable "node_pool_size" {
  default     = "1"
  description = "Pool Size"
}

variable "node_pool_shape" {
  default     = "VM.Standard.E3.Flex"
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node"
}


variable "tenancy_id" {
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
  type        = string
}


variable "node_pool_node_shape_config_ocpus" {
  default     = "1" # Only used if flex shape is selected
  description = "You can customize the number of OCPUs to a flexible shape"
}
variable "node_pool_node_shape_config_memory_in_gbs" {
  default     = "16" # Only used if flex shape is selected
  description = "You can customize the amount of memory allocated to a flexible shape"
}

variable "image_operating_system" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}
variable "image_operating_system_version" {
  default     = "7.9"
  description = "The OS/image version installed on all nodes in the node pool."
}

variable "node_pool_boot_volume_size_in_gbs" {
  default     = "50"
  description = "Specify a custom boot volume size (in GB)"
}
