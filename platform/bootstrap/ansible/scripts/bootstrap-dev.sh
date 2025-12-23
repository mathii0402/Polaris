#!/usr/bin/env bash
set -euo pipefail

# ------------------------------
#  Polaris Dev Bootstrap Script
#  Purpose: Install ansible & run dev ansible playbook with live logs
# ------------------------------

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${YELLOW}📦 Polaris Dev Environment Bootstrap Started...${NC}"

# ------------------------------
# 1. Install dependencies
# ------------------------------

echo -e "${YELLOW}➡ Installing system dependencies...${NC}"
sudo apt update -y
sudo apt install -y software-properties-common curl git python3 python3-pip

# ------------------------------
# 2. Install Ansible (latest stable)
# ------------------------------

if ! command -v ansible >/dev/null 2>&1; then
    echo -e "${YELLOW}➡ Installing Ansible...${NC}"

    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

    echo -e "${GREEN}✔ Ansible installed${NC}"
else
    echo -e "${GREEN}✔ Ansible already installed${NC}"
fi

# ------------------------------
# 3. Run Ansible Playbook with Live Logs
# ------------------------------

echo -e "${YELLOW}➡ Running Ansible Dev setup playbook...${NC}"

ANSIBLE_INVENTORY="$ROOT_DIR/bootstrap/ansible/inventory/dev"
ANSIBLE_PLAYBOOK="$ROOT_DIR/bootstrap/playbooks/dev-setup.yaml"

# --verbose (-vvv) shows live task-by-task output
ansible-playbook -i "$ANSIBLE_INVENTORY" "$ANSIBLE_PLAYBOOK" -vvv | tee bootstrap-dev.log

STATUS=$?

if [ $STATUS -ne 0 ]; then
    echo -e "${RED}❌ Ansible playbook failed. See bootstrap-dev.log for details.${NC}"
    exit $STATUS
fi

echo -e "${GREEN}✅ Polaris Dev Environment setup completed successfully!${NC}"
echo -e "${GREEN}📝 Logs saved to bootstrap-dev.log${NC}"
