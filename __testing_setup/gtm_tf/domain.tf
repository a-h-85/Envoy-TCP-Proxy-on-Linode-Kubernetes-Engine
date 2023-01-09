#DOMAIN
resource "akamai_gtm_domain" "lke-envoy" {
    name = var.gtm_domain_name                     # Domain Name
    type = "basic"               # Domain type product flavour
    group = var.groupid         # Group ID variable
    contract = var.contractid     # Contract ID variable
    email_notification_list = [var.notification_email]        # email notification list
    comment = var.gtm_domain_name
    default_timeout_penalty   = 25
    load_imbalance_percentage = 200
    default_error_penalty     = 75
    cname_coalescing_enabled  = false
    load_feedback             = false
    end_user_mapping_enabled  = false
}