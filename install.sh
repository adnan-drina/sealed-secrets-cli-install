#!/bin/bash

#Make sure you're connected to your OpenShift cluster with admin user before running this script

echo "Creating Sealed Secrets namespace"
oc apply -f ss-namespace.yaml
echo "Sealed Secrets namespace created!"
echo " "
echo "Creating Sealed Secrets OperatorGroup"
oc apply -f ss-og.yaml
echo "Sealed Secrets OperatorGroup created!"
echo " "
echo "Creating Sealed Secrets Subscription"
oc apply -f ss-sub.yaml
exho "wait for sub"
SS_SUB="$(oc get subs -o name -n sealed-secrets | grep sealed-secrets-operator)"
oc -n sealed-secrets wait --timeout=120s --for=condition=CatalogSourcesUnhealthy=False ${SS_SUB}
exho "wait for operator"
SS_OPER="$(oc get pods -o name -n sealed-secrets | grep sealed-secrets-operator-)"
oc -n sealed-secrets wait --timeout=120s --for=condition=Ready ${SS_OPER}
echo "Sealed Secrets Subscription created!"
echo " "
echo "Creating Sealed Secrets Controller"
oc apply -f ss-cr.yaml
echo "Sealed Secrets Controller created!"