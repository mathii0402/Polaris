#!/usr/bin/env bash
set -e

echo "===== CLEANING UP DEV TOOLS (Docker, k8s tools, Kind, Skaffold, K9s) ====="

# ---------------------------
# Docker Cleanup
# ---------------------------
echo "-> Removing Docker packages..."
sudo apt remove -y docker-ce docker-ce-cli containerd.io || true
sudo apt purge  -y docker-ce docker-ce-cli containerd.io || true

echo "-> Removing Docker data directories..."
sudo rm -rf /var/lib/docker /var/lib/containerd || true

echo "-> Removing Docker config & repo files..."
sudo rm -f /etc/docker/daemon.json
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

sudo systemctl stop docker || true
sudo systemctl disable docker || true

# ---------------------------
# kubectl Cleanup
# ---------------------------
echo "-> Removing kubectl..."
sudo apt remove -y kubectl || true
sudo rm -f /usr/local/bin/kubectl || true
sudo rm -f /etc/apt/sources.list.d/kubernetes.list || true

sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg || true

# ---------------------------
# Helm Cleanup
# ---------------------------
echo "-> Removing Helm..."
sudo rm -f /usr/local/bin/helm || true

# ---------------------------
# K9s Cleanup
# ---------------------------
echo "-> Removing K9s..."
sudo rm -f /usr/local/bin/k9s || true
sudo rm -rf /usr/local/bin/k9s* || true
sudo rm -rf ~/.config/k9s || true

# ---------------------------
# Skaffold Cleanup
# ---------------------------
echo "-> Removing Skaffold..."
sudo rm -f /usr/local/bin/skaffold || true

# ---------------------------
# Kind Cleanup
# ---------------------------
echo "-> Removing Kind..."
sudo rm -f /usr/local/bin/kind || true

echo "-> Deleting any existing kind clusters..."
kind delete cluster || true

echo "-> Removing kubeconfig..."
rm -f ~/.kube/config || true
rm -rf ~/.kube || true

# ---------------------------
# APT Cleanup
# ---------------------------
echo "-> Cleaning apt..."
sudo apt autoremove -y || true
sudo apt autoclean -y || true

echo "===== CLEANUP COMPLETE ====="
