# Commands
## Port-forwarding
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8181:80

# To enable side-car for existing pods using linkerd 
kubectl annotate namespace polaris-apps linkerd.io/inject=enabled
kubectl rollout restart deployment user-service -n polaris-apps
kubectl rollout restart deployment order-service -n polaris-apps

