#!/bin/bash

#7 Deploy Akamai GTM via Terraform
cd gtm_tf

echo '-----------'
echo "Deploy Akamai GTM via Terraform"
terraform init && terraform plan && terraform apply
echo 'Akamai GTM successfully created.'
echo 'CNAME your applications DNS to '$GTM_PROPERTY_NAME'.'$GTM_DOMAIN_NAME
echo '-----------'

cd ..