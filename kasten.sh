#!/bin/bash
# echo "$(tput setaf 4)Create new cluster"
# minikube start --addons volumesnapshots,csi-hostpath-driver,ingress --apiserver-port=6443 --container-runtime=containerd -p se-demo

echo "$(tput setaf 4)update helm repos if already present"
helm repo update

echo "$(tput setaf 4)Deploy Kasten K10"

helm repo add kasten https://charts.kasten.io/

kubectl create namespace kasten-io
helm install k10 kasten/k10 --namespace=kasten-io --set auth.tokenAuth.enabled=true --set ingress.create=true

echo "$(tput setaf 4)Annotate Volumesnapshotclass"

kubectl annotate volumesnapshotclass csi-hostpath-snapclass \
    k10.kasten.io/is-snapshot-class=true

echo "$(tput setaf 4)Change default storageclass"

kubectl patch storageclass csi-hostpath-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

### Set permissions

kubectl create clusterrolebinding serviceaccounts-cluster-admin --clusterrole=cluster-admin --group=system:serviceaccounts

kubectl create clusterrolebinding kastenadmin --clusterrole=k10-admin --user=default
  
  
echo "$(tput setaf 4)Display K10 Token Authentication" 
TOKEN=$(kubectl --namespace kasten-io create token default --duration=24h | cut -d " " -f 1)

echo "$(tput setaf 3)Token value: "
echo "$(tput setaf 3)$TOKEN"

echo "$(tput setaf 3)Our Dashboard should be exposed by ingress so head to http://192.168.49.2/k10"
echo "$(tput setaf 4)Environment Complete"
