#!/bin/bash

#echo "Type your project prefix (<PROJECT_PREFIX>-cicd), followed by [ENTER]:"
#read NAMESPACE

declare PROJECT_PREFIX="cicd"
PROJECT_PREFIX=$1
NAMESPACE=$(PROJECT_PREFIX)-cicd

echo $(NAMESPACE)

# Installing Sealed Secretes in CICD namespace needed for kam bootstrap
# Define a namespace where you want to install sealed secrets
# NAMESPACE="<APP-NAME>-cicd"

sed -i -e "s|cicd|$NAMESPACE|g" kam-ss/*.yaml
# Start installing
echo "Creating Sealed Secrets namespace"
oc apply -f kam-ss/ss-namespace.yaml
echo "Sealed Secrets namespace created!"
echo " "
echo "Creating Sealed Secrets OperatorGroup"
oc apply -f kam-ss/ss-og.yaml
echo "Sealed Secrets OperatorGroup created!"
echo " "
echo "Creating Sealed Secrets Subscription"
oc apply -f kam-ss/ss-sub.yaml
SS="$(oc get subs -o name -n $NAMESPACE | grep sealed-secrets-operator)"
oc -n $NAMESPACE wait --timeout=120s --for=condition=CatalogSourcesUnhealthy=False ${SS}
echo "Sealed Secrets Subscription created!"
echo " "
echo "Creating Sealed Secrets Controller"
oc apply -f kam-ss/ss-cr.yaml
echo "Sealed Secrets Controller created!"