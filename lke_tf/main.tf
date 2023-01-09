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
module "ap-southeast" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-ap-southeast"
  region        = "ap-southeast"
}
module "us-central" {
  source           = "./cluster_module"
  clucluster_label = "${var.cluster_name}-us-central"
  region           = "us-central"
}
module "us-west" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-us-west"
  region        = "us-west"
}
module "us-southeast" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-us-southeast"
  region        = "us-southeast"
}
module "us-east" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-us-east"
  region        = "us-east"
}
module "eu-west" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-eu-west"
  region        = "eu-west"
}
module "ap-south" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-ap-south"
  region        = "ap-south"
}
module "eu-central" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-eu-central"
  region        = "eu-central"
}
module "ap-northeast" {
  source        = "./cluster_module"
  cluster_label = "${var.cluster_name}-ap-northeast"
  region        = "ap-northeast"
}
