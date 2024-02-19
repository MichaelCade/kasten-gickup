# kasten-gickup

## Purpose 
The purpose of this repository is to provide a template for using Gickup within a Kubernetes cluster and then leveraging Kasten K10 to orchestrate Source Code Repository backups to an Object Storage location of which this could be immutable. 

In the first MVP of this you will find the following files within this repository.

- `gickup-deployment.yaml` - Uses an image that has gickup binary and kando to ensure we can backup and then send our data to our Object Storage location. 

- `gickup-config.yaml` contains configuration on our source, destination and logging 

- `gickup-secret.yaml` contains our GitHub Secret but this could also contain any other sensitive information. 

- `gickup-pv-pvc.yaml` A volume to store our initial backup chain.

## Deployment 

In order to use the above you will need to edit the files above, you will need a GitHub Secret added and then choose the configuration required for source and destination. 

Once you have the above edited then you can deploy this to your cluster, for my testing I used a dedicated namespace called `gickup` for ease of management and also to be able to annotate later when it comes to the blueprint. 

You will also need Kasten K10 installed. 


## Blueprint 
At this stage you can also deploy the `gickup-blueprint-k10.yaml` 

```
kubectl apply -f gickup-blueprint-k10.yaml -n kasten-io
```

When you have K10 deployed you will need to annotate the deployment we deployed above so the blueprint is associated to that workload. 

```
kubectl --namespace=gickup annotate deployment/gickup-deployment \
> kanister.kasten.io/blueprint=gickup-blueprint
```

## Kasten K10 

Now we are ready to create a new K10 policy for protecting our workloads, you will also need an object storage location configured to send our backups too. 
