#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

mkdir -p certs
pushd certs
echo -e "\n\e[0;32m${bold}Creating Root CA ${normal}"
make -f ../tools/certs/Makefile.selfsigned.mk root-ca

echo -e "\n\e[0;32m${bold}Creating Intermediate CA${normal}"
make -f ../tools/certs/Makefile.selfsigned.mk sunbird-rc-primary-cacerts
make -f ../tools/certs/Makefile.selfsigned.mk sunbird-rc-secondary-cacerts

echo -e "\n\e[0;32m${bold}Creating k8s secrets in primary cluster ${normal}"
export KUBECONFIG=/var/lib/jenkins/secrets/k8s.yaml
kubectl create namespace istio-system
kubectl create secret generic cacerts -n istio-system \
      --from-file=sunbird-rc-primary/ca-cert.pem \
      --from-file=sunbird-rc-primary/ca-key.pem \
      --from-file=sunbird-rc-primary/root-cert.pem \
      --from-file=sunbird-rc-primary/cert-chain.pem

echo -e "\n\e[0;32m${bold}Creating k8s secrets in secondary cluster ${normal}"
export KUBECONFIG=/var/lib/jenkins/secrets/k8s-secondary.yaml
kubectl create namespace istio-system
kubectl create secret generic cacerts -n istio-system \
      --from-file=sunbird-rc-secondary/ca-cert.pem \
      --from-file=sunbird-rc-secondary/ca-key.pem \
      --from-file=sunbird-rc-secondary/root-cert.pem \
      --from-file=sunbird-rc-secondary/cert-chain.pem

popd