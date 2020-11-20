# sealed-secrets-cli-install
Install Sealed Secrets as Kubernetes Operator via the Operator Lifecyle Manager of your cluster.

## Setup

### Inspect the Operator information

we want to get information about the current operator csv and its provided API. First thing is to ensure that the operator exists in the channel catalog.
```shell script
oc get packagemanifests -n openshift-marketplace | grep sealed-secrets
```

Now we want to get the CSV information that we will use later.
```shell script
oc describe packagemanifests/sealed-secrets-operator-helm -n openshift-marketplace
```

### Create a namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    openshift.io/description: "Sealed Secrets Operator project for encrypting secrets"
    openshift.io/display-name: "sealed-secrets"
  name: sealed-secrets
```
or 
```shell script
oc new-project sealed-secrets
```

### Create a Subscription

As per the documentation ["`A user wanting a specific operator creates a Subscription which identifies a catalog, operator and channel within that operator. The Catalog Operator then receives that information and queries the catalog for the latest version of the channel requested. Then it looks up the appropriate ClusterServiceVersion identified by the channel and turns that into an InstallPlan.`"](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/design/architecture.md#catalog-operator)

So we will create a subscription

**[subscription.yaml](subscription.yaml).**

```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: sealed-secrets-operator
  namespace: sealed-secrets
spec:
  channel: alpha
  installPlanApproval: Automatic
  name: sealed-secrets-operator-helm
  source: community-operators
  sourceNamespace: openshift-marketplace
  startingCSV: sealed-secrets-operator-helm.v0.0.2 
```

-   the starting CSV version we want, it should match the current CSV

It is possible to configure how OLM deploys an Operator via the config field in the Subscription object.

### Create an Operator Group

An OperatorGroup is an OLM resource that provides multitenant configuration to OLM-installed Operators. An OperatorGroup selects target namespaces in which to generate required RBAC access for its member Operators.

**[operatorgroup.yaml](operatorgroup.yaml).**

```yaml
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  annotations:
    olm.providedAPIs: SealedSecretController.v1alpha1.bitnami.com
  generateName: sealed-secrets-
  name: sealed-secrets
  namespace: sealed-secrets
spec:
  targetNamespaces:
  - sealed-secrets
```

-   The annotation’s value is a string consisting of GroupVersionKinds (GVKs) in the format of &lt;kind&gt;.&lt;version&gt;.&lt;group&gt; delimited with commas. The GVKs of CRDs and APIServices provided by all active member CSVs of an OperatorGroup are included.

-   Target namespace selection, explicitly name the target namespace for an OperatorGroup. We define "sealed-secrets" as the target namespace that will be watched.

### Deploy the Operator
```shell script
oc apply -f namespace.yaml
oc apply -f operatorgroup.yaml
oc apply -f subscription.yaml
```