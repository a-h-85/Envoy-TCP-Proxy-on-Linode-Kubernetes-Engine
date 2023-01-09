#!/bin/bash

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

