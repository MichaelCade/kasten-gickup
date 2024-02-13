# kasten-gickup

Notes 

```
kubectl --namespace=gickup annotate deployment/gickup-deployment \
> kanister.kasten.io/blueprint=gickup-blueprint
```

```
kubectl apply -f gickup-blueprint.yaml -n kasten-io
```


kubectl --namespace kasten-io port-forward service/gateway 8080:80