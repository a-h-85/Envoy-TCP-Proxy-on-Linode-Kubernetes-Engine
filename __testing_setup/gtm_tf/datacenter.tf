#DATACENTER
resource "akamai_gtm_datacenter" "ap-west" {
    domain = akamai_gtm_domain.lke-envoy.name     # domain
    nickname = "ap-west"               # Datacenter Nickname
    city = "Mumbai"
    continent = "AS"
    country = "IN"
    cloud_server_host_header_override = false
    cloud_server_targeting            = false
    depends_on = [akamai_gtm_domain.lke-envoy]
}

resource "akamai_gtm_datacenter" "ca-central" {
    domain = akamai_gtm_domain.lke-envoy.name     # domain
    nickname = "ca-central"               # Datacenter Nickname
    city = "Toronto"
    continent = "NA"
    country = "CA"
    cloud_server_host_header_override = false
    cloud_server_targeting            = false
    depends_on = [akamai_gtm_domain.lke-envoy]
}