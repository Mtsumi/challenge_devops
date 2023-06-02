#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t|--tag)
      IMAGE_TAG="$2"
      shift # past argument
      shift # past value
      ;;
    *) 
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Checking if the image tag is provided
if [ -z "$IMAGE_TAG" ]; then
  echo "Image tag not provided. Please specify the image tag using the -t or --tag option."
  exit 1
fi

# Deploy or update nginx deployment
kubectl apply -f nginx-deployment.yaml

# Set the image tag in the deployment
kubectl set image deployment/nginx-deployment nginx=nginx:$IMAGE_TAG
