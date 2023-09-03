terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}


provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.istio_regions["home"]
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  alias            = "home"
}


provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.istio_regions["cls1_region"]
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  alias            = "cls1"
}

provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.istio_regions["cls2_region"]
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  alias            = "cls2"
}


