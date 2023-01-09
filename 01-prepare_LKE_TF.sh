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