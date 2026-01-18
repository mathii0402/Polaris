#!/bin/bash
echo "=== Fixing Missing File References ==="

# 1. Fix double .yaml extensions
echo "1. Checking for double .yaml extensions..."
find platform/addons -name "*.yaml.yaml" | while read file; do
  new_name="${file%.yaml}"  # Remove one .yaml
  echo "Renaming: $file → $new_name"
  mv "$file" "$new_name"
done

# 2. Check each directory for actual files
for dir in platform/addons/*/; do
  dir=${dir%/}  # Remove trailing slash
  echo -e "\n2. Checking: $dir"
  
  if [ -f "$dir/kustomization.yaml" ]; then
    echo "   Found kustomization.yaml"
    
    # Check if referenced files exist
    while read -r line; do
      if [[ $line =~ ^-.*\.yaml$ ]]; then
        file=$(echo $line | sed 's/^- //')
        full_path="$dir/$file"
        
        if [ -f "$full_path" ]; then
          echo "   ✅ $file exists"
        else
          echo "   ❌ $file MISSING - removing from kustomization"
          # Remove the line from kustomization.yaml
          sed -i "\|^-\s*$file$|d" "$dir/kustomization.yaml"
        fi
      fi
    done < "$dir/kustomization.yaml"
  fi
done

# 3. Create proper kustomization files
echo -e "\n3. Creating correct kustomization files..."

# For istio
cat > platform/addons/istio/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- namespace-labels.yaml
- install/istio-base.yaml
- install/istiod.yaml
- install/istio-ingress.yaml
- policies/default-deny.yaml
- policies/default-mtls.yaml

namespace: istio-system
EOF

# For observability
cat > platform/addons/observability/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- prometheus.yaml
- grafana.yaml
- kiali.yaml

namespace: istio-system  # Note: Istio addons go to istio-system
EOF

# For ingress-nginx
cat > platform/addons/ingress-nginx/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- polaris-ingress.yaml

namespace: ingress-nginx
EOF

# For network-policies
cat > platform/addons/network-policies/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- zero-trust-policy.yaml
- orders-allow-users-policy.yaml
- user-and-order-allows-postgres-policy.yaml

namespace: polaris-apps
EOF

echo "✅ Done!"