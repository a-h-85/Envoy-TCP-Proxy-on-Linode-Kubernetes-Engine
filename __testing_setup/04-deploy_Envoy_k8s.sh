#!/bin/bash

#4 Deploy Envoy to all LKE clusters
echo '-----------'
echo "Deploy Envoy Proxy to all LKE clusters"
echo "AP-WEST"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ap-west
echo "CA-CENTRAL"
kubectl apply -f ./envoy_k8s/lke-envoy-deployment.yaml --kubeconfig ./lke_tf/kubeconfig-$LKE_CLUSTER_NAME-ca-central
echo 'Envoy Proxy successfully deployed to all LKE clusters.'
echo '-----------'
