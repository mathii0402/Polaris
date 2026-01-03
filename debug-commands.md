# Commands

## kind image load command
kind load docker-image order-service:1.0 --name polaris-dev

## Port-forwarding
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8181:80

# To enable side-car for existing pods using linkerd 
kubectl annotate namespace polaris-apps linkerd.io/inject=enabled
kubectl rollout restart deployment user-service -n polaris-apps
kubectl rollout restart deployment order-service -n polaris-apps

# linkerd path command
export PATH=$PATH:$HOME/.linkerd2/bin   



# CURL COMMANDS
# From any pod in the cluster
curl http://user-service-api.polaris-apps.svc.cluster.local/users/1

# Or just service name (same namespace)
curl http://user-service-api/users/1

# outside the pod inside the cluster and is we have enabled nodeport

# Get node IP first
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}') 

# Then use Node IP + NodePort
curl http://${NODE_IP}:30001/users/1

# Montioring using istio (Note: use the correct versions)

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.28/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.28/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.28/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.23/samples/addons/jaeger.yaml

# Access Dashboard
# Kiali (Service Mesh Dashboard)
istioctl dashboard kiali

# Prometheus
istioctl dashboard prometheus

# Grafana
istioctl dashboard grafana

# Jaeger
istioctl dashboard jaeger