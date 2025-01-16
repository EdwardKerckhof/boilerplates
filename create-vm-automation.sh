#!/bin/bash

# Variables
TERRAFORM_DIR="./terraform/proxmox"
ANSIBLE_DIR="./ansible"
ANSIBLE_PLAYBOOK="./playbooks/setup-new-ubuntu-server.yaml"
LOG_FILE="./automation.log"

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Functions
log() {
    echo -e "${GREEN}[INFO]${RESET} $1"
    echo "[INFO] $1" >>"$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
    echo "[ERROR] $1" >>"$LOG_FILE"
    exit 1
}

# Check if required tools are installed
check_tools() {
    for tool in terraform ansible-playbook; do
        if ! command -v "$tool" &>/dev/null; then
            error "Required tool '$tool' is not installed. Please install it and try again."
        fi
    done
}

# Apply Terraform configurations
apply_terraform() {
    log "Changing directory to Terraform: $TERRAFORM_DIR"
    cd "$TERRAFORM_DIR" || error "Failed to change directory to $TERRAFORM_DIR"

    if [[ "$1" == "-y" ]]; then
        log "Running 'terraform apply' with auto-approval"
        terraform apply -auto-approve || error "Terraform apply failed."
    else
        log "Running 'terraform apply'"
        terraform apply || error "Terraform apply failed."
    fi

    log "Terraform apply completed successfully."
    cd - &>/dev/null || exit
}

# Run Ansible playbook
run_ansible() {
    log "Changing directory to Ansible: $ANSIBLE_DIR"
    cd "$ANSIBLE_DIR" || error "Failed to change directory to $ANSIBLE_DIR"

    log "Running Ansible playbook: $ANSIBLE_PLAYBOOK"
    ansible-playbook "$ANSIBLE_PLAYBOOK" || error "Ansible playbook execution failed."
    log "Ansible playbook completed successfully."
    cd - &>/dev/null || exit
}

# Main script
main() {
    log "Starting new VM automation script..."
    check_tools
    apply_terraform "$1"
    run_ansible
    log "Automation script completed successfully."
}

# Execute main script with arguments
main "$1"
