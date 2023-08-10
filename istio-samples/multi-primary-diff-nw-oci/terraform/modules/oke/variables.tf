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

