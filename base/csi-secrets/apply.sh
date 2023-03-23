#!/bin/bash


# apply eks
# eksctl create cluster -f eks.yaml

# service account
kubectl apply -f 1-service-account.yaml

# CSI driver
kubectl apply -f secrets-store-csi-driver

# AWS secret config provider
kubectl apply -f aws-provider-installer

# secret proviver class
kubectl apply -f 2-secret-provider-class.yaml

# Deploy the application
kubectl apply -f 3-deployment.yaml
