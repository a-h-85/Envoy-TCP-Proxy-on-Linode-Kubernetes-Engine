#!/bin/bash

#1 Set envirnment variables to populate the variables.tf file for the LKE Terraform deployment
cd lke_tf

echo '-----------'
echo "Define LKE Cluster Name and Linode Personal Access Token"
touch lke_variables.txt
read -p "Enter LKE Cluster Name: " LKE_CLUSTER_NAME
echo "LKE_CLUSTER_NAME: " $LKE_CLUSTER_NAME >> lke_variables.txt
read -p "Enter Linode Personal Access Token: " TOKEN
echo "Linode Personal Access Token: " $TOKEN >> lke_variables.txt
echo '-----------'
echo "Linode Connfiguration"
echo "LKE_CLUSTER_NAME: $LKE_CLUSTER_NAME"
echo "TOKEN: $TOKEN"
echo '-----------'
echo "lke_variables.txt"
cat lke_variables.txt
echo '-----------'

export LKE_CLUSTER_NAME
export TOKEN

echo "Update LKE variables.tf files"
envsubst < variables.tf.template > variables.tf
cd cluster_module
envsubst < variables.tf.template > variables.tf
echo './lke_tf/variables.tf and ./lke_tf/cluster_module/variables.tf files generated from variables.tf.template'
echo '-----------'

cd ..
cd ..

#2 Use Terraform to deploy LKE cluster in all regions
echo '-----------'
echo "Deploy LKE Kubernetes Clusters in all Linode regions"
cd lke_tf && terraform init && terraform plan && terraform apply
echo 'LKE clusters successfully created.'
echo '-----------'

cd ..

#3 Collect input variables and update Envoy configuration file
cd envoy_k8s

echo '-----------'
echo "Define Envoy Proxy Configuration"
touch envoy_variables.txt
read -p "Enter Custom Port used by application: " ENVOY_CSTM_PORT
echo "ENVOY_CSTM_PORT: " $ENVOY_CSTM_PORT >> envoy_variables.txt
read -p "Enter Forward Port used by proxy to connect to Akamai platform (80 or 443): " ENVOY_FWD_PORT
echo "ENVOY_FWD_PORT: " $ENVOY_FWD_PORT >> envoy_variables.txt
read -p "Enter Akamai Edgehostname to be used as Forward destination by proxy: " ENVOY_FWD_EHN
echo "ENVOY_FWD_EHN: " $ENVOY_FWD_EHN >> envoy_variables.txt
echo '-----------'
echo "Envoy Connfiguration"
echo "ENVOY_CSTM_PORT: $ENVOY_CSTM_PORT"
echo "ENVOY_FWD_PORT: $ENVOY_FWD_PORT"
echo "ENVOY_FWD_EHN: $ENVOY_FWD_EHN"
echo '-----------'
echo 'envoy_variables.txt'
cat envoy_variables.txt
echo '-----------'

export ENVOY_CSTM_PORT
export ENVOY_FWD_PORT
export ENVOY_FWD_EHN

echo "Update Envoy Proxy Kubernetes deployment file"
envsubst < lke-envoy-deployment.yaml.template > lke-envoy-deployment.yaml
echo 'lke-envoy-deployment.yaml file generated from lke-envoy-deployment.yaml.template'
echo '-----------'

cd ..

#4 Deploy Envoy to all LKE clusters
echo '-----------'
echo "Deploy Envoy Proxy to all LKE clusters"
echo "AP-WEST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-west
echo "CA-CENTRAL"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ca-central
echo "AP-SOUTHEAST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-southeast
echo "US-CENTRAL"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-central
echo "US-WEST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-west
echo "US-SOUTHEAST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-southeast
echo "US-EAST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-east
echo "EU-WEST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-west
echo "AP-SOUTH"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-south
echo "EU-CENTRAL"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-central
echo "AP-NORTHEAST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-northeast
echo 'Envoy Proxy successfully deployed to all LKE clusters.'
echo '-----------'

#5 Deploy metrics-server to all LKE clusters
echo '-----------'
echo "Deploy metrics-server to all LKE clusters"
echo "AP-WEST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-west
echo "CA-CENTRAL"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ca-central
echo "AP-SOUTHEAST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-southeast
echo "US-CENTRAL"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-central
echo "US-WEST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-west
echo "US-SOUTHEAST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-southeast
echo "US-EAST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-east
echo "EU-WEST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-west
echo "AP-SOUTH"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-south
echo "EU-CENTRAL"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-central
echo "AP-NORTHEAST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-northeast
echo 'metrics-server successfully deployed to all LKE clusters.'
echo '-----------'

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
export APSOUTHEAST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-southeast | jq -r ".status.loadBalancer.ingress[0].ip")
echo "APSOUTHEAST: " $APSOUTHEAST
echo "APSOUTHEAST: " $APSOUTHEAST >> ./gtm_tf/locations.txt
export USCENTRAL=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-central | jq -r ".status.loadBalancer.ingress[0].ip")
echo "USCENTRAL: " $USCENTRAL
echo "USCENTRAL: " $USCENTRAL >> ./gtm_tf/locations.txt
export USWEST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-west | jq -r ".status.loadBalancer.ingress[0].ip")
echo "USWEST: " $USWEST
echo "USWEST: " $USWEST >> ./gtm_tf/locations.txt
export USSOUTHEAST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-southeast | jq -r ".status.loadBalancer.ingress[0].ip")
echo "USSOUTHEAST: " $USSOUTHEAST
echo "USSOUTHEAST: " $USSOUTHEAST >> ./gtm_tf/locations.txt
export USEAST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-us-east | jq -r ".status.loadBalancer.ingress[0].ip")
echo "USEAST: " $USEAST
echo "USEAST: " $USEAST >> ./gtm_tf/locations.txt
export EUWEST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-west | jq -r ".status.loadBalancer.ingress[0].ip")
echo "EUWEST: " $EUWEST
echo "EUWEST: " $EUWEST >> ./gtm_tf/locations.txt
export APSOUTH=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-south | jq -r ".status.loadBalancer.ingress[0].ip")
echo "APSOUTH: " $APSOUTH
echo "APSOUTH: " $APSOUTH >> ./gtm_tf/locations.txt
export EUCENTRAL=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-eu-central | jq -r ".status.loadBalancer.ingress[0].ip")
echo "EUCENTRAL: " $EUCENTRAL
echo "EUCENTRAL: " $EUCENTRAL >> ./gtm_tf/locations.txt
export APNORTHEAST=$(kubectl get service envoy --namespace=envoy -o json --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-northeast | jq -r ".status.loadBalancer.ingress[0].ip")
echo "APNORTHEAST: " $APNORTHEAST
echo "APNORTHEAST: " $APNORTHEAST >> ./gtm_tf/locations.txt
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

#7 Deploy Akamai GTM via Terraform
cd gtm_tf

echo '-----------'
echo "Deploy Akamai GTM via Terraform"
terraform init && terraform plan && terraform apply
echo 'Akamai GTM successfully created.'
echo 'CNAME your applications DNS to '$GTM_PROPERTY_NAME'.'$GTM_DOMAIN_NAME
echo '-----------'

cd ..