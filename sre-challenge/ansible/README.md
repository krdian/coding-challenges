# Ansible Playbook Documentation

## Overview

This playbook automates server configuration and package management for a mixed environment of Debian and RedHat-based systems.

## Environment Note

This playbook is configured for Debian servers instead of Ubuntu, as Debian is used in the home lab environment.

## Playbook Tasks

### 1. Gather Server Facts

The playbook begins by collecting detailed system information from all servers in the inventory using Ansible facts.

### 2. Package Upgrades

- Upgrades system packages on both Debian and RedHat family servers
- Handles package manager differences automatically (apt vs yum)

### 3. Apache Web Server Installation

- Installs and configures Apache HTTP server
- Deploys a simple "Hello World!" landing page
- **Scope**: Applies only to Debian servers

### 4. MariaDB Database Server Installation

- Installs MariaDB database server
- **Scope**: Applies only to RedHat-based servers

## Execution Guide

### Prerequisites

1. Ensure your user account has sudo privileges on target servers
2. Create an encrypted secrets file using Ansible Vault

### Create Encrypted Credentials

```bash
ansible-vault create secrets.yaml
```

Add your ansible_become_password variable to the encrypted file.

### Run the Playbook

```bash
ansible-playbook -i inventory.ini main.yaml
```

### Using Vault-Protected Secrets

If your secrets file is encrypted, use:

```bash
ansible-playbook -i inventory.ini main.yaml --ask-vault-pass
```

or

```bash
ansible-playbook -i inventory.ini main.yaml --vault-password-file /path/to/vault-password-file
```
