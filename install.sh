#!/bin/bash

#Make sure you're connected to your OpenShift cluster with admin user before running this script

#echo "Creating Sealed Secrets namespace"
#oc apply -f ss-namespace.yaml
#echo "Sealed Secrets namespace created!"
#echo " "
#echo "Creating Sealed Secrets OperatorGroup"
#oc apply -f ss-og.yaml
#echo "Sealed Secrets OperatorGroup created!"
#echo " "
#echo "Creating Sealed Secrets Subscription"
#oc apply -f ss-sub.yaml
#echo "Sealed Secrets Subscription created!"
#echo " "
#echo "Creating Sealed Secrets Controller"
#oc apply -f ss-cr.yaml
#echo "Sealed Secrets Controller created!"

#Installing Sealed Secretes in CICD namespace needed for kam bootstrap
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
echo "Sealed Secrets Subscription created!"
echo " "
echo "Creating Sealed Secrets Controller"
oc apply -f kam-ss/ss-cr.yaml
echo "Sealed Secrets Controller created!"