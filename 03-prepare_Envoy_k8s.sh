#!/bin/bash

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