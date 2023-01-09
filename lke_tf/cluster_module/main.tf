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
  tags        = ["envoy", "${var.cluster_label}", "${var.cluster_name}", "${var.region}"]

  control_plane {
    high_availability = true
  }

  pool {
    type  = "g6-dedicated-2"
    count = 3

    autoscaler {
      min = 3
      max = 6
    }
  }

  # Prevent the count field from overriding autoscaler-created nodes
  lifecycle {
    ignore_changes = [
      pool.0.count
    ]
  }
}
