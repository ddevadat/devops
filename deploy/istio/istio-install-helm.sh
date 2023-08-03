#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

echo -e "\n\e[0;32m${bold}Configure the Helm repository ${normal}"
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update


install_istio_helm() {

      istio_namespace="istio-system"
      echo -e "\n\e[0;32m${bold}Istio Install in $2 cluster ${normal}"
      export KUBECONFIG=$1
      # Use kubectl to check if the namespace exists
      if kubectl get namespace "$istio_namespace" &> /dev/null; then
      echo "Namespace '$istio_namespace' exists."
      else
      echo "Namespace '$istio_namespace' does not exist. Creating namespace '$istio_namespace'"
      kubectl create namespace istio-system
      fi

      echo "Install the Istio base chart"
      helm install istio-base istio/base -n istio-system --set defaultRevision=default
      sleep 10
      helm ls -n istio-system

      echo "Install the Istio discovery chart"
      helm install istiod istio/istiod -n istio-system --wait
      helm status istiod -n istio-system

      sleep 30
      echo "Check istiod service is successfully installed and its pods are running"
      kubectl get deployments -n istio-system --output wide

}

#install_istio_helm /var/lib/jenkins/secrets/k8s.yaml primary
install_istio_helm /var/lib/jenkins/secrets/k8s-secondary.yaml secondary



