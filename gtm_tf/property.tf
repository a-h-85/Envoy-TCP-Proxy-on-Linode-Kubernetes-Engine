#PROPERTY
resource "akamai_gtm_property" "lke-envoy" {
  domain                      = akamai_gtm_domain.lke-envoy.name # domain
  name                        = var.gtm_property_name            # Property Name
  type                        = "performance"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 300
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  load_imbalance_percentage   = 500
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.ap-west.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.apwest]
    name          = "ap-west"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.ca-central.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.cacentral]
    name          = "ca-central"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.ap-southeast.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.apsoutheast]
    name          = "ap-southeast"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-central.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.uscentral]
    name          = "us-central"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-west.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.uswest]
    name          = "us-west"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-southeast.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.ussoutheast]
    name          = "us-southeast"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-east.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.useast]
    name          = "us-east"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.eu-west.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.euwest]
    name          = "eu-west"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.ap-south.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.apsouth]
    name          = "ap-south"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.eu-central.datacenter_id
    enabled       = true
    weight        = 10
    servers       = [var.eucentral]
    name          = "eu-central"
    handout_cname = ""
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.ap-northeast.datacenter_id
    enabled       = true
    weight        = 9
    servers       = [var.apnortheast]
    name          = ""
    handout_cname = "ap-northeast"
  }
  depends_on = [
    akamai_gtm_domain.lke-envoy,
    akamai_gtm_datacenter.ap-west,
    akamai_gtm_datacenter.ca-central,
    akamai_gtm_datacenter.ap-southeast,
    akamai_gtm_datacenter.us-central,
    akamai_gtm_datacenter.us-west,
    akamai_gtm_datacenter.us-southeast,
    akamai_gtm_datacenter.us-east,
    akamai_gtm_datacenter.eu-west,
    akamai_gtm_datacenter.ap-south,
    akamai_gtm_datacenter.eu-central,
    akamai_gtm_datacenter.ap-northeast
  ]
}
