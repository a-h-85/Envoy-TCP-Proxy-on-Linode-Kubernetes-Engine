terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.4"
    }
  }
}

//Use the Linode Provider
provider "linode" {
  token = var.token
}

resource "linode_lke_cluster" "lke_cluster" {
    label       = var.cluster_label
    k8s_version = "1.24"
    region      = var.region
    tags        =  ["envoy","${var.cluster_label}","${var.cluster_name}","${var.region}"]

  pool {
        type  = "g6-standard-2"
        count = 1
    }
}