# Polaris Dev Environment Bootstrap

This repository provides a one-command bootstrap for setting up the Polaris local development environment using Bash and Ansible.  
It provisions a complete Kubernetes-based dev platform using Kind along with all required tooling.

---

## What This Setup Does

The bootstrap process will:

- Install required system dependencies
- Install and configure Ansible
- Install Docker and configure user access
- Install Kubernetes tooling:
  - kubectl
  - kind
  - helm
  - k9s
  - skaffold
- Create a Kind Kubernetes cluster (`polaris-dev`)
- Configure kubeconfig for the developer user (no sudo required)
- Create platform namespaces:
  - polaris-apps
  - polaris-data


---

## Setup the Dev Environment

### Bootstrap (Recommended)

Run the bootstrap script:

```bash
./bootstrap-dev.sh
```
This installs Ansible (if needed) and runs the dev setup playbook with live logs saved to bootstrap-dev.log.

### Manual Recovery (If Bootstrap Fails)

If the script fails in the middle, you can safely re-run Ansible manually:

```bash
ansible-playbook \
  -i /home/mathi/Polaris/platform/bootstrap/ansible/inventory/dev.ini \
  /home/mathi/Polaris/platform/bootstrap/ansible/playbooks/dev-setup.yaml
```

### Cleanup

To clean up the local development environment:

```bash
    ./cleanup.sh
```
This removes the Kind cluster and related Kubernetes resources (system packages are not removed).


## Verification
```bash
kubectl get nodes
kubectl get ns
```