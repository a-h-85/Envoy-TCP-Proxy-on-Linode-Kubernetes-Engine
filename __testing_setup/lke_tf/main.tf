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

//create an lke cluster in each linode region
module "ap-west" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-ap-west"
  region        = "ap-west"
}
module "ca-central" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-ca-central"
  region        = "ca-central"
}