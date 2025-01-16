variable "masters_count" {
  description = "Amount of master nodes to create"
  type        = number
  default     = 1
}

variable "workers_count" {
  description = "Amount of worker nodes to create"
  type        = number
  default     = 2
}

variable "vm_template" {
  description = "Template to clone from"
  type        = string
  default     = "ubuntu-cloud"
}

resource "proxmox_vm_qemu" "masters" {
  count = var.masters_count
  name = format("master-%02d", count.index + 1)
  target_node = "hydra"
  vmid = 300 + count.index
  desc = format("Master node %02d", count.index + 1)
  tags = "kubernetes,rke2,ubuntu"

  clone = var.vm_template
  full_clone = true

  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  os_type = "cloud-init"

  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  vga {
    type = "std"
    memory = 4
  }

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "apps"
          size = 20
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

  ipconfig0 = format("ip=10.8.8.%d/24,gw=10.8.8.1", 160 + count.index)
  ciuser = "edward"
  ciupgrade = true

  sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMnM797XOLqn/sc6mx9PyxWwed+neKWG+E2AdxJfguH edwardkerckhof@hotmail.com
  EOF
}

resource "proxmox_vm_qemu" "workers" {
  count = var.workers_count
  name = format("worker-%02d", count.index + 1)
  target_node = "hydra"
  vmid = 310 + count.index
  desc = format("Worker node %02d", count.index + 1)
  tags = "kubernetes,rke2,ubuntu"

  clone = var.vm_template
  full_clone = true

  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  os_type = "cloud-init"

  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  vga {
    type = "std"
    memory = 4
  }

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "apps"
          size = 20
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

  ipconfig0 = format("ip=10.8.8.%d/24,gw=10.8.8.1", 165 + count.index)
  ciuser = "edward"
  ciupgrade = true

  sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMnM797XOLqn/sc6mx9PyxWwed+neKWG+E2AdxJfguH edwardkerckhof@hotmail.com
  EOF
}
