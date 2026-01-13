# 1. Create namespace
kubectl create namespace argocd

# 2. Install ArgoCD (official manifest)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Wait for pods
kubectl wait --for=condition=ready pod -n argocd -l app.kubernetes.io/name=argocd-server --timeout=120s

# 4. Get password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo ""

# 5. Access
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "✅ ArgoCD UI: https://localhost:8080"
echo "👤 Username: admin"