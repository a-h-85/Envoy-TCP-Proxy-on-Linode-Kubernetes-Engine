#DATACENTER
resource "akamai_gtm_datacenter" "ap-west" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "ap-west"                        # Datacenter Nickname
  city                              = "Mumbai"
  continent                         = "AS"
  country                           = "IN"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "ca-central" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "ca-central"                     # Datacenter Nickname
  city                              = "Toronto"
  continent                         = "NA"
  country                           = "CA"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "ap-southeast" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "ap-southeast"                   # Datacenter Nickname
  city                              = "Sydney"
  continent                         = "OC"
  country                           = "AU"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "us-central" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "us-central"                     # Datacenter Nickname
  city                              = "Dallas"
  continent                         = "NA"
  country                           = "US"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "us-west" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "us-west"                        # Datacenter Nickname
  city                              = "Freemont"
  continent                         = "NA"
  country                           = "US"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "us-southeast" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "us-southeast"                   # Datacenter Nickname
  city                              = "Atlanta"
  continent                         = "NA"
  country                           = "US"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "us-east" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "us-east"                        # Datacenter Nickname
  city                              = "Newark"
  continent                         = "NA"
  country                           = "US"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "eu-west" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "eu-west"                        # Datacenter Nickname
  city                              = "London"
  continent                         = "EU"
  country                           = "UK"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "ap-south" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "ap-south"                       # Datacenter Nickname
  city                              = "Singapore"
  continent                         = "AS"
  country                           = "SG"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "eu-central" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "eu-central"                     # Datacenter Nickname
  city                              = "Frankfurt"
  continent                         = "EU"
  country                           = "DE"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "ap-northeast" {
  domain                            = akamai_gtm_domain.lke-envoy.name # domain
  nickname                          = "ap-northeast"                   # Datacenter Nickname
  city                              = "Tokyo"
  continent                         = "AS"
  country                           = "JP"
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on                        = [akamai_gtm_domain.lke-envoy]
}
