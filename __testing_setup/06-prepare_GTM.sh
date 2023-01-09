#!/bin/bash

#6 Preparing Akamai GTM Terraform deployment

# Get External LKE IPs of Envoy to populate GTM Terraform configuration files
echo "Wait 5 minutes for k8s to properly initialize"
sleep 300
echo '-----------'
echo "Fetch external IPs of LKE Clusters"
touch ./gtm_tf/locations.txt
export APWEST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-west | jq -r ".status.loadBalancer.ingress[0].ip")
echo "APWEST: " $APWEST
echo "APWEST: " $APWEST >> ./gtm_tf/locations.txt
export CACENTRAL=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ca-central | jq -r ".status.loadBalancer.ingress[0].ip")
echo "CACENTRAL: " $CACENTRAL
echo "CACENTRAL: " $CACENTRAL >> ./gtm_tf/locations.txt
echo '-----------'
echo './gtm_tf/locations.txt'
cat ./gtm_tf/locations.txt
echo '-----------'

# Collect Akamai GTM input information
echo "Define Akamai GTM variables"
touch ./gtm_tf/gtm_variables.txt
read -p "Enter Akamai Contract ID: " AKAM_CONTRACT_ID
echo "AKAM_CONTRACT_ID: " $AKAM_CONTRACT_ID >> ./gtm_tf/gtm_variables.txt
read -p "Enter Akamai Group ID: " AKAM_GROUP_ID
echo "AKAM_GROUP_ID: " $AKAM_GROUP_ID >> ./gtm_tf/gtm_variables.txt
read -p "Enter Akamai GTM notification email: " GTM_NOTIFICATION_EMAIL
echo "GTM_NOTIFICATION_EMAIL: " $GTM_NOTIFICATION_EMAIL >> ./gtm_tf/gtm_variables.txt
read -p "Enter Akamai GTM Domain name (must end with .akadns.net): " GTM_DOMAIN_NAME
echo "GTM_DOMAIN_NAME: " $GTM_DOMAIN_NAME >> ./gtm_tf/gtm_variables.txt
read -p "Enter Akamai GTM Property name: " GTM_PROPERTY_NAME
echo "GTM_PROPERTY_NAME: " $GTM_PROPERTY_NAME >> ./gtm_tf/gtm_variables.txt
echo '-----------'
echo "GTM Connfiguration"
echo "AKAM_CONTRACT_ID: $AKAM_CONTRACT_ID"
echo "AKAM_GROUP_ID: $AKAM_GROUP_ID"
echo "GTM_NOTIFICATION_EMAIL: $GTM_NOTIFICATION_EMAIL"
echo "GTM_DOMAIN_NAME: $GTM_DOMAIN_NAME"
echo "GTM_PROPERTY_NAME: $GTM_PROPERTY_NAME"
echo '-----------'
echo './gtm_tf/gtm_variables.txt'
cat ./gtm_tf/gtm_variables.txt
echo '-----------'

export AKAM_CONTRACT_ID
export AKAM_GROUP_ID
export GTM_NOTIFICATION_EMAIL
export GTM_DOMAIN_NAME
export GTM_PROPERTY_NAME

#update TF variables file with collected information
cd gtm_tf

echo "Update GTM Terraform deplyoment variables file"
envsubst < terraform.tfvars.template > terraform.tfvars
echo 'terraform.tfvars file generated from terraform.tfvars.template'
echo '-----------'

cd ..