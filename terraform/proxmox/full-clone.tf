# Proxmox Full-Clone
# ---
# Create a new VM from a clone

variable "vm_target_node" {
  description = "Target node for the VM"
  type        = string
  default     = "hydra"
}

variable "vm_id" {
  description = "ID for the VM"
  type        = string
  default     = "300"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "test-terraform"
}

variable "vm_desc" {
  description = "Description of the VM"
  type        = string
  default     = "Testing Terraform"
}

variable "vm_nameserver" {
  description = "Nameserver of the VM"
  type        = string
  default     = "10.8.8.130"
}

variable "vm_disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 20
}

resource "proxmox_vm_qemu" "test-terraform" {
    # VM General Settings
    target_node = var.vm_target_node
    vmid = var.vm_id
    name = var.vm_name
    desc = var.vm_desc
    tags = "ubuntu,terraform"

    # VM Advanced General Settings
    onboot = true

    # VM OS Settings
    clone = "ubuntu-cloud"
    full_clone = true

    # VM System Settings
    agent = 1

    # VM CPU Settings
    cores = 1
    sockets = 1
    vcpus = 0
    cpu = "host"

    # VM Memory Settings
    memory = 2048

    vga {
        type = "serial0"
    }

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # VM Disk Settings
    scsihw   = "virtio-scsi-single"
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "apps"
                  size = var.vm_disk_size
                }
            }
        }
        ide {
            ide2 {
                cloudinit {
                    storage = "apps"
                }
            }
        }
    }

    ipconfig0 = "ip=10.8.8.135/24,gw=10.8.8.1"
    ciuser = "edward"
    ciupgrade = true
    nameserver = var.vm_nameserver

    sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMnM797XOLqn/sc6mx9PyxWwed+neKWG+E2AdxJfguH edwardkerckhof@hotmail.com
    EOF
}
