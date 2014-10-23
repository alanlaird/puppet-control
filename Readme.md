# Puppet Control Repo

## Overview

This is an all-in-one repo that is a skeleton to use in a production environment, but also can be used to share and test Puppet infrastructure.

The idea is that this environment controls all of your environments (dev, qa, production) but also holds the ability to spin up Vagrant VMs to test your code before committing.

NOTE: Internet access is required for this environment

## Files/Directories

### Vagrantfile

Dictates basics of how Vagrant will spin up VM. Please do not edit this file unless you *really* know what you're doing.

### code/

This contains a `control` directory. The contents of this directory is what ends up as your environment files on the Puppet Master itself, be it in the Vagrant VM or your production Master. Here's a brief explaination of what's inside!

###### Puppetfile
r10k needs this file to figure out what component modules you want from the Forge.

###### environment.conf
Controls puppet's directory environment settings.

###### hieradata
Contains your hiera data files.

###### manifests
Contains site.pp

###### site
Contains your organization-specific roles and profiles (wrappers for Forge component modules)

### provision/

Contains the script and files that are used to spin up the Vagrant VM. This is different from the Vagrantfile in that these are more specific to what you want to happen with the specific instance. The pe/ directory contains answer files, and, after you spin up PE for the first time, will contain PE installation media, which are in .gitignore.

### reference/
Reference materials for Puppet workflow.

### vagrant.yml

Gives instructions to Vagrantfile regarding what Vagrant box you want to use, and what virtual machines are available for provisioning, and what their options should be.

## How to use it

There's two systems in this environment:

| Name    | Description                  | Address        | App URL                                                  |
| ------- | ---------------------------- | -------------- | -------------------------------------------------------- |
| xmaster | The PE Master                | 192.168.137.10 | [https://192.168.137.10](https://192.168.137.10)         |
| xagent  | Example agent (unclassified) | 192.168.137.14 |                                                          |

The default credentials for the PE Master Console are:

Username: `admin@example.com`

Password: `password`

### Summary of procedure

1. Bring up instances
2. Push local control repository to Git server
3. Experiment

**Bring up all the nodes in the Vagrant environment:**

```shell
vagrant up
```

(optionally, just bring up the master, gitlab server, and whatever agent you
want)

This will take some time to provision.

Ensure that the PE master is up and provisioned before attempting to start
another system.

The main things for demonstration:

* Puppet Environments (control repository)
* Roles and Profiles
* Hiera
* Git/VCS workflow
* Optionally, [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml)
* [r10k](https://github.com/adrienthebo/r10k)
* [trlinkin/noop](https://github.com/trlinkin/trlinkin-noop)

### 1. Install Puppet

Although really you should have it installed on your local machine already.

### 2. Install puppet-lint

```
gem install puppet-lint
```

### 3. Install Virtualbox

This vagrant setup requires one of the following versions: 4.0, 4.1, 4.2. The latest Virtualbox version is 4.3

### 4. Install Vagrant

Latest version, 1.5.6 when this repo was created, will work fine.


### Provisioning Summary

The Vagrant provisioning will install Puppet Enterprise with the appropriate
configuration for each system.  The Puppet Master will be configured and manged
using Puppet - you can look at the `role::puppet::master` to see what's going
on.  Basically, Puppet is configured for environments, r10k is installed and
configured, and Hiera is installed and configured.  During provisioning, the
provided control repository is cloned to the PE master and a local `puppet apply`
is done for the role.


Classification for all nodes are done via the
environment-specific `site.pp` using hiera_include


## Other

This makes use of Greg Sarjeant's [data-driven-vagrantfile](https://github.com/gsarjeant/data-driven-vagrantfile)

No Vagrant plugins are required.
