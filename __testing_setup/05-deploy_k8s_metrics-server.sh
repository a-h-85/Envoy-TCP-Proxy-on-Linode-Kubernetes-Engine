#!/bin/bash

#5 Deploy metrics-server to all LKE clusters
echo '-----------'
echo "Deploy metrics-server to all LKE clusters"
echo "AP-WEST"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-west
echo "CA-CENTRAL"
kubectl apply -f ./envoy_k8s/metrics-server.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ca-central
echo 'metrics-server successfully deployed to all LKE clusters.'
echo '-----------'

