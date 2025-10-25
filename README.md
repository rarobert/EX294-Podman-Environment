A practice environment for the Red Hat Certified Engineer (RHCE) EX294 exam.

> [!NOTE]
> Requires a Linux host

> [!TIP]
> ansible-navigator is __not__ installed. This lab is designed primarily for `ansible` or `ansible-playbook` commands.

Run the script `bin/deploy.sh` to:
- Install `podman` and `podman-compose` on the host, if not present
- Configure the root password for all nodes (default is `qwerty`)
- Build the local node image (from the Rocky Linux UBI 10 base) with systemd
- Deploy the node stack (control and managed nodes)

Once this runs you will automatically be connected to the control node to start practicing.

Access to the control node can be performed manually with `podman exec -it ex294_control /bin/bash`.

The `bin/restart.sh` script will bring down the stack; removing containers and the container network, and redeploy the lab. It __won't__ remove `podman` or `podman-compose`.

## Ansible-Navigator
Ansible-navigator is not installed or used as part of this practice lab.

## Setup
Following other similar setups, this compose file will create one control node and four managed nodes:
- control.example.com (172.28.128.100)
- node1.example.com (172.28.128.101)
- node2.example.com (172.28.128.102)
- node3.example.com (172.28.128.103)
- node4.example.com (172.28.128.104)

## Questions
> [!TIP]
> If you have to leave the control node's terminal when answering questions, take note of the question for later review.

## Note
These nodes do NOT:
- Have Ansible or Python installed on them.
- Have password-less SSH access (although password root access is configured).
- Some packages outside of the UBI are installed for QoL (sshpass, sudo)
