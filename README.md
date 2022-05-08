# Terraform module for OCI Compute Instances running podman containers

IMPORTANT: default configuration is designed to use only Always Free resources. If you change instance shape or instance count, charges may apply.

NOTE: Always Free compute instances must be created in your Home Region (the region you selected during account registration).

Detailed information about Oracle Cloud Infrastructure Always Free resources can be found in [official documentation](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm).

This module is used as a Stack in OCI Resource Manager and creates the following resources:

- Virtual Cloud Network (VCN)
- Subnet
- Route Table
- Internet Gateway
- Security List (allow ingress port: 22/tcp)
- Virtual Machine (VM) Compute Instances (Shape: VM.Standard.E2.1.Micro, count: 2)

Podman is installed on the VMs from cloud-init. Containers are managed by systemd service units.

## Quickstart guide

1. Download the [latest](releases/latest) release of this module in *zip* format.
1. Create an account at [Oracle Cloud](https://signup.cloud.oracle.com/) - you'll need a valid CC with $1 for verification.
1. In [Oracle Cloud Console](https://cloud.oracle.com/), open the navigation menu and click **Developer Services**. Under **Resource Manager**, click **Stacks**. Alternatevely, you can get to **Stacks** by entering the word "stacks" in the search bar.
1. Choose a compartment on the left side of the page ("root" compartment is OK). Click **Create Stack**.
1. You are now at **Stack Information** page. For origin of the Terraform configuration, select **My Configuration**; for **Stack Configuration**, select **.Zip file**. Then either click *Browse* or drag-n-drop the zip file that you downloaded at step 1. Click **Next**.
1. You are now at **Configure Variables** page. If you want to run Always Free resources leave everything as is. You may want to provide your ssh public key at this step or else RSA 4096 key pair will be generated and you can get its private part from outputs later. Click **Next**.
1. You are now at **Review** page. Select **Run Apply** checkbox at the bottom of the page and click **Create**.
1. Wait for about 10-15 minutes for full VMs provisioning (podman installation takes up to 10mins).
1. Look at graphs of each VM (**Instances** => <instance_name> => **Metrics**).
1. If you're not a housewife, you may want to login to the instances via SSH and execute some commands.

## SSH login info

Example of `~/.ssh/config` for quick connect:

```
Host podman-instance-1
  Hostname 140.238.221.180
  User opc
  IdentityFile ~/.ssh/id_ed25519

Host podman-instance-2
  Hostname 140.238.170.47
  User opc
  IdentityFile ~/.ssh/id_ed25519
```

so you can connect by `ssh podman-instance-1` and `ssh podman-instance-2`.

Or use a full command without adding hosts to ssh config: `ssh opc@140.238.221.180 -i ~/.ssh/id_ed25519`

## Useful commands

The following examples use `mhddos_proxy` as a container name, replace it with appropriate name for other containers.

NOTE: execute all the below commands as root (do `sudo -i` after ssh login). <Tab> key autocompletion works fine there, use it!

### Container start/stop management via systemd

Show container's systemd service unit

```
systemctl cat container-mhddos_proxy.service
```

Stop/start/restart the container via systemd:

```
systemctl stop container-mhddos_proxy.service
systemctl start container-mhddos_proxy.service
systemctl restart container-mhddos_proxy.service
```

Check/disable/enable container's start on reboot:

```
systemctl is-enabled container-mhddos_proxy.service
systemctl disable container-mhddos_proxy.service
systemctl enable container-mhddos_proxy.service
```

### Container status

Systemd service status and logs:

```
systemctl status container-mhddos_proxy.service
journalctl -u container-mhddos_proxy.service
```

List currently running containers:

```
podman ps
```

List all containers (including stopped and created):

```
podman ps --all
```

Display a live stream of container's resource usage statistics:

```
podman stats
```

### Container output and interaction

Retrieve all logs from the container (following the output):

```
podman logs -f mhddos_proxy
```

Attach to the running container:

```
podman attach mhddos_proxy
```

NOTE: Detach with *ctrl-p,ctrl-q* key sequence; and: *ctrl-c* will stop the container.

## Possible improvements & ideas

- Add custom compute image with preinstalled podman (and prefetched container images) to speed the things up
- Add types and descriptions to variables in `variables.tf`
