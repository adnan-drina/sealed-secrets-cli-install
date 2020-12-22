#!/bin/bash

#Make sure you're connected to your OpenShift cluster with admin user before running this script

echo "Creating Sealed Secrets namespace"
oc apply -f ss-namespace.yaml
echo "Sealed Secrets namespace created!"

echo "Creating Sealed Secrets OperatorGroup"
oc apply -f ss-og.yaml
echo "Sealed Secrets OperatorGroup created!"

echo "Creating Sealed Secrets Subscription"
oc apply -f ss-sub.yaml
echo "Sealed Secrets Subscription created!"
