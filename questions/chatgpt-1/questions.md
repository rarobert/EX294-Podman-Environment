Excellent — let’s build you a realistic, hands-on RHCE (EX294) practice exam based on RHEL 9, with a control node (control.example.com) and four managed nodes (node1–node4).

This simulation mirrors the structure and style of the real exam:

    Total Points: 300

    Passing Score: 210 (70%)

    Focus: Automation of system administration tasks using Ansible.

    Setup:

        Control node IP: 172.28.128.100

        Managed nodes:

            node1.example.com → 172.28.128.101

            node2.example.com → 172.28.128.102

            node3.example.com → 172.28.128.103

            node4.example.com → 172.28.128.104

🧭 RHCE Practice Exam (EX294 Simulation)

Scenario:
You are the DevOps administrator responsible for automating configurations across a cluster of Red Hat Enterprise Linux 9 servers. You will use Ansible to perform the following tasks. Unless otherwise stated:

    Use /home/admin/ansible as your working directory.

    Use the inventory file /home/admin/ansible/inventory.

    Use YAML syntax for all playbooks and roles.

    Use FQDN hostnames for managed nodes.

Section 1 – Environment Configuration (50 points)

1. Inventory Setup (10 pts)
Create a static inventory file at /home/admin/ansible/inventory with the following groups:

[webservers]
node1.example.com
node2.example.com

[dbservers]
node3.example.com

[storage]
node4.example.com

Confirm Ansible connectivity with:

ansible all -m ping

2. Ansible Configuration (10 pts)
Create an Ansible configuration file at /home/admin/ansible/ansible.cfg that:

    Sets the inventory to /home/admin/ansible/inventory

    Disables host key checking

    Sets remote user to devops

    Uses /home/admin/ansible/roles for role paths

3. Privilege Escalation (10 pts)
Configure the environment so that Ansible can use privilege escalation (become: true) without prompting for a password.

4. Ad Hoc Testing (20 pts)
Run an ad hoc command to ensure all systems have the package vim-enhanced installed.
Section 2 – Playbook Automation (150 points)

5. Webserver Configuration (30 pts)
Create a playbook /home/admin/ansible/web.yml that:

    Applies to hosts in the webservers group

    Installs and enables the httpd service

    Ensures the service is running and enabled at boot

    Creates a file /var/www/html/index.html with the content:

    Welcome to {{ inventory_hostname }} - managed by Ansible

6. Database Configuration (30 pts)
Create /home/admin/ansible/db.yml that:

    Runs on dbservers

    Installs the mariadb-server package

    Starts and enables the mariadb service

    Opens TCP port 3306 using firewalld

    Ensures SELinux allows database network connections

7. Users and Groups (30 pts)
Create a playbook /home/admin/ansible/users.yml that:

    Creates a group devteam

    Creates users alice and bob in that group

    Sets their default shell to /bin/bash

    Deploys SSH authorized keys from /home/admin/ansible/files/keys/{{ item }}.pub

8. File Distribution and Permissions (30 pts)
Create /home/admin/ansible/files.yml to:

    Copy /etc/motd from the control node to /etc/motd on all nodes

    Set ownership to root:root and mode to 0644

    Ensure a directory /data/shared exists with mode 2775 and group ownership devteam

9. Conditional Configuration (30 pts)
Create /home/admin/ansible/conditional.yml that:

    Runs on all nodes

    If the host belongs to the group webservers, install mod_ssl

    If the host belongs to dbservers, install python3-PyMySQL

    If the host belongs to storage, create a file /etc/storage.info containing Storage Node

Section 3 – Roles and Variables (100 points)

10. Create a Role (40 pts)
Create a role named apache in /home/admin/ansible/roles/apache that:

    Installs and configures the httpd service

    Uses a Jinja2 template for /var/www/html/index.html

    Template file should include:

    This is {{ ansible_hostname }}
    Managed by the apache role

11. Role Application (30 pts)
Create a playbook /home/admin/ansible/site.yml that:

    Applies the apache role to all webservers

    Defines a variable http_port with value 8080

    Configures the httpd service to listen on that port

12. Include and Use Variables (30 pts)
Create a file /home/admin/ansible/group_vars/webservers.yml that sets:

welcome_msg: "Hello from Ansible on a webserver"

Modify the role’s template to include:

{{ welcome_msg }}

Section 4 – Advanced Automation (Bonus: 30 points)

13. Using Handlers (15 pts)
Modify one of your playbooks so that when a configuration file changes, the corresponding service is restarted only when necessary.

14. Loop and Register Usage (15 pts)
Create /home/admin/ansible/check_packages.yml that:

    Checks for the packages httpd, mariadb-server, and firewalld

    Registers the results

    Displays a message summarizing which packages are installed or missing on each host

16. Systemd Timer Job (30 pts)

Goal:
Automate a recurring cleanup script using ansible.builtin.systemd and ansible.builtin.copy modules.

Requirements:

    Create /usr/local/bin/cleanup_logs.sh on all hosts:

    #!/bin/bash
    find /var/log -type f -mtime +7 -delete

    Ensure it’s executable.

    Create a systemd service named cleanup-logs.service:

        Executes /usr/local/bin/cleanup_logs.sh

    Create a systemd timer named cleanup-logs.timer:

        Runs the service daily at 03:00

    Enable and start the timer using Ansible.

Key modules:
ansible.builtin.copy, ansible.builtin.file, ansible.builtin.systemd
17. Manage Kernel Tunables (sysctl) with Handlers (30 pts)

Goal:
Configure persistent kernel networking parameters and ensure changes trigger a system reload.

Requirements:

    Create /home/admin/ansible/sysctl.yml:

        Applies to all nodes

        Ensures the following settings persist in /etc/sysctl.d/99-network.conf:

net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1

Use ansible.posix.sysctl module with reload: no

Add a handler named "reload sysctl" that runs:

        ansible.builtin.command: sysctl -p /etc/sysctl.d/99-network.conf

        Notify this handler when settings are changed.

Key modules:
ansible.posix.sysctl, ansible.builtin.command
18. Firewall Rules with Rich Language (30 pts)

Goal:
Use the ansible.posix.firewalld module with rich rules to restrict traffic.

Requirements:

    Target: webservers

    Create /home/admin/ansible/firewall_rich.yml

    Apply the following:

        Allow inbound HTTPS (443/tcp) only from 172.28.128.0/24

        Drop all other inbound connections to 443/tcp

        Ensure permanent configuration is applied and reloaded

Example rich rule (concept):

rule family="ipv4" source address="172.28.128.0/24" port port=443 protocol=tcp accept

Key modules:
ansible.posix.firewalld (with rich_rule), ansible.builtin.service
19. Archive and Transfer Logs (30 pts)

Goal:
Demonstrate data handling and remote archiving using community modules.

Requirements:

    On node4.example.com (the storage node):

        Collect /var/log directory into /data/log_backup.tar.gz

        Use community.general.archive

    Transfer the archive from node4 to control.example.com in /home/admin/backups/
    (Hint: use ansible.builtin.fetch or community.general.synchronize)

    Verify the resulting archive exists and is non-empty.

Key modules:
community.general.archive, ansible.builtin.fetch or community.general.synchronize
20. Dynamic Facts and JSON Querying (30 pts)

Goal:
Create custom facts and use ansible.utils.json_query for filtering.

Requirements:

    On all nodes, create a custom fact file /etc/ansible/facts.d/system.fact:

    [system]
    role=web
    environment=production

    (Change role per host group: webservers=web, dbservers=db, storage=storage)

    Create /home/admin/ansible/facts.yml that:

        Gathers these custom facts

        Uses ansible.utils.json_query to display only hosts whose role == "web"

        Prints their hostname and environment.

21. Create a filesystem

22. File mount