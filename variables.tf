variable "tenancy_ocid" {}

variable "compartment_ocid" {}

variable "region" {}

variable "prefix" {
  description = "Prefix for resource names"
  default     = "podman"
}

variable "ssh_public_key" {
  default = ""
}

variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_count" {
  default = 2
}

variable "container_image" {
  default = "ghcr.io/porthole-ascend-cinnamon/mhddos_proxy"
}

variable "container_image_args" {
  default = "-t 2000 --itarmy --debug --vpn"
}
