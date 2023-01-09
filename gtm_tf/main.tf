terraform {
  required_providers {
    akamai = {
      source = "akamai/akamai"
    }
  }
}

# Configure the Akamai Provider
provider "akamai" {
  edgerc         = "~/.edgerc"
  config_section = "default"
}
