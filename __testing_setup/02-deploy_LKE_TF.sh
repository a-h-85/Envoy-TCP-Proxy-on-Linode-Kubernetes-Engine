#!/bin/bash

#2 Use Terraform to deploy LKE cluster in all regions
echo '-----------'
echo "Deploy LKE Kubernetes Clusters in all Linode regions"
cd lke_tf && terraform init && terraform plan && terraform apply
echo 'LKE clusters successfully created.'
echo '-----------'

cd ..