## Download Istio
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH


## Install minimal + ingress
istioctl install \
  --set profile=demo \
  --set values.global.proxy.resources.requests.cpu=50m \
  --set values.global.proxy.resources.requests.memory=64Mi \
  -y

# Verify installation
istioctl version
kubectl get pods -n istio-system

## Enable mesh for Polaris namespace
kubectl label namespace polaris-apps istio-injection=enabled
