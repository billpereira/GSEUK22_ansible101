# GSEUK22_ansible101
Repository for Ansible 101 course with hands on activities

## Infra as Code approach

Usually our changes to infrastructure has to happen out of business hours, is common to have complex tasks to be executed on weekend evenings. Looking for an automated process where we can avoid human errors we map our activities, the configuration, our infrastructure.

The coding of our infrastructure will be the input of the automation tool we use, in this case we will have Ansible as our tool.

There are 2 types of IaC, declaratve and imperative. 

The declarative approach

## Quick introduction to Ansible engines

Ansible is an automation engine that can be used across multiple platforms for cloud provision, network management, application deployment and orchestration. Recently IBM has addeed to the vast se of Options it has, specific modules for Mainframe environment.

It help us adopt to bring infrastructure as code. Let's take a scenario wher we have to execute multiple tasks during a maintenance period, usually this is out of business hours. If we can create a receipt, a step by step instructions of the tasks we need to create, we can add this tasks into a file called `playbook`. It then can be executed across multiple environments saving us time and helping to avoid human errors.
 
To be able to replicate this actions Ansible will find all servers, hosts from the `Inventory`. It could be a static file, or it could be sourced from an online CMDB.

On it's engine, Ansible  have some structure that encapsulate functions to help us, some modules and plugins that have the scripts needed for specific action, and all we need to do is provide the data for this to run, to go to our hosts through an `SSH - Secure Shell` connection. This is in fact other advantage of Ansible, it doesnt need to have an agent installed on the hosts it will manage.

https://docs.ansible.com/ansible-core/2.12/index.html

## Getting started with our environment

To avoid any local installation, we will use the GitPod IDE for our practices: https://gitpot.io

Let's use our github account to connect and create the workspace using this repository as base.

For mainframe practices we will use an id on ZXplore: https://ibmzxplore.influitive.com/

With credentials in hand, add execution flag to script `get_started.sh` and then execute it passing your userid `z99999`. After it starts it will ask for your password.

```
gitpod /workspace/GSEUK22_ansible101 (main) $ chmod +x get_started.sh 
gitpod /workspace/GSEUK22_ansible101 (main) $ ./get_started.sh z12309
Password:
```

After the scripts ends, you should see the ansible config of your environment:
```
Successfully installed ansible-6.4.0 ansible-core-2.13.4 resolvelib-0.8.1
ansible [core 2.13.4]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/gitpod/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /workspace/.pyenv_mirror/user/current/lib/python3.8/site-packages/ansible
  ansible collection location = /home/gitpod/.ansible/collections:/usr/share/ansible/collections
  executable location = /workspace/.pyenv_mirror/user/3.8.13/bin/ansible
  python version = 3.8.13 (default, Sep  6 2022, 16:33:03) [GCC 9.4.0]
  jinja version = 3.1.2
  libyaml = True
```
And the inventory with data for the ZXplore lpar will be ready.

## Ansible AD HOC Commands

```
gitpod /workspace/GSEUK22_ansible101 (main) $ ansible localhost -m file -a "path=./templates state=directory"
localhost | CHANGED => {
    "changed": true,
    "gid": 33333,
    "group": "gitpod",
    "mode": "0755",
    "owner": "gitpod",
    "path": "./templates",
    "size": 6,
    "state": "directory",
    "uid": 33333
}
gitpod /workspace/GSEUK22_ansible101 (main) $ ansible localhost -m shell -a "ls -al"
localhost | CHANGED | rc=0 >>
total 16
drwxr-xr-x 4 gitpod gitpod  113 Sep 23 08:43 .
drwxr-xr-x 7 gitpod gitpod  104 Sep 23 08:38 ..
-rwxr-xr-x 1 gitpod gitpod 1525 Sep 23 08:38 get_started.sh
drwxr-xr-x 8 gitpod gitpod  181 Sep 23 08:38 .git
-rw-r--r-- 1 gitpod gitpod  769 Sep 23 08:39 inventory.yaml
-rw-r--r-- 1 gitpod gitpod  130 Sep 23 08:38 ping.yaml
-rw-r--r-- 1 gitpod gitpod   80 Sep 23 08:38 README.md
drwxr-xr-x 2 gitpod gitpod    6 Sep 23 08:43 templates
gitpod /workspace/GSEUK22_ansible101 (main) $ ansible -i inventory.yaml zxplore -m ping
zxplore | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Ansible Playbooks

### YAML - YAML ain't markup language

So now you are probably asking how do we provide these instructions for Ansible, how we provide these data?

The language we use is the YAML, that stands for YAML Ain't Markup Language, it's a data serialization language often used for writing configuration files.

Let's take a look on how we can get started with YAML files. One of the things that is very common is to have pairs `key: value`.

```
key: value
name: Tony
age: 35
date: 13-07-2022
member_of_gse: true
```

One important thing about YAML files, it's oriented by identation, so let's look other example:

```
gse_member:
  name: Tony
  start_date: 13-07-2022
  talk: Zowe
```

Now when we use the identation, we transformed all those keys(name, start_date, speciality) into properties of gis_team_member, this is similar to when we add a object as property of a key in JSON.

If we need to represent a list of team members on this YAML, all we need is make use of `-` and the identation

```
gis_team_member:
  - name: Tony
    start_date: 13-07-2022
    talk: Zowe

  - name: Sylvia
    start_date: 1-06-2021
    talk: DB2
```

This gives a basic understanding for us to continue, but more detailed documentation can be found on:

https://yaml.org/spec/1.2.2/