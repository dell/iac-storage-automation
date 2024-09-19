# Using Dell CSI for PowerMax on Harvester

Dell CSI drivers for PowerStore, PowerMax, PowerFlex and PowerScale
are all tested and compatible with Kubevirt.

The following article gives the instructions to install Dell CSI
for PowerMax on Harvester.
The steps are very similar no matter the storage backend.

This procedure has been tested on:

* Haverster v1.3.1
* CSM v2.11
* For PowerMax protocols Fiber Channel, iSCSI and NFS

> Note: at the time of this publication, Harvester allows 3rd party storage
> for non-boot volume or for Virtual Machine created from an ISO installation

# Documentation

Before you begin, we highly recommend to read the
[official Dell Container Storage Modules documentation](https://dell.github.io/csm-docs/docs/).
This website has all the information to deploy, configure and manage
Dell CSI drivers & other modules.

Dell CSI drivers are available as [Helm charts](https://github.com/dell/helm-charts)
or [Operator](https://operatorhub.io/).
In the following guide we will use the Helm deployment method
applied to [CSI PowerMax](https://dell.github.io/csm-docs/docs/deployment/helm/drivers/installation/powermax/).

# Connect to Harvester cluster
To use `helm` and `kubectl` let's first download the `KUBECONFIG`:
![harvester download kubeconfig](harvester-get-kubeconfig.gif)

# Pre-requisites

## Multipathd
When using block storage protocols like Fiber Channel, iSCSI or NVMe
it is mandatory to configure the mulitpathd service.

```bash
kubectl apply -f 
```


## Namespace & Secret creation

# Helm installation

# StorageClasses creation

# Haverster `csi-driver-config`

To enable Virtual Machine snapshots with Dell backed volume it
is necessary to add the provisionner.

To do so, go under __Advanced__ > __Settings__ > __csi-driver-config__ > __Edit Setting__.

In the case of PowerMax the configuration will look like:

```json
{
  "driver.longhorn.io": {
    "volumeSnapshotClassName": "longhorn-snapshot",
    "backupVolumeSnapshotClassName": "longhorn"
  },
  "csi-powermax.dellemc.com": {
    "volumeSnapshotClassName": "powermax-snapclass",
    "backupVolumeSnapshotClassName": "powermax-snapclass"
  }
}
```
