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

On it's engine, Ansible have some structure that encapsulate functions to help us, some modules and plugins that have the scripts needed for specific action, and all we need to do is provide the data for this to run, to go to our hosts through an `SSH - Secure Shell` connection. This is in fact other advantage of Ansible, it doesnt need to have an agent installed on the hosts it will manage.

https://docs.ansible.com/ansible-core/2.12/index.html

## Getting started with our environment

To avoid any local installation, we will use the GitPod IDE for our practices: https://gitpot.io

Let's use our github account to connect and create the workspace using this repository as base.

For mainframe practices we will use an id on ZXplore: https://ibmzxplore.influitive.com/

With credentials in hand, add execution flag to script `get_started.sh` and then execute it passing your userid `z99999`. After it starts it will ask for your password.

```
gitpod /workspace/GSEUK22_ansible101 (main) $ chmod +x get_started.sh
gitpod /workspace/GSEUK22_ansible101 (main) $ ./get_started.sh
MF USERID:
Password:
```

After the scripts ends, you can see the ansible config of your environment with `ansible --version`:

```
Successfully installed ansible-6.4.0 ansible-core-2.13.4 resolvelib-0.8.1
gitpod /workspace/GSEUK22_ansible101 (main) $ ansible --version
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
gitpod /workspace/GSEUK22_ansible101 (main) $ ansible localhost -m file -a "path=./test_folder state=directory"
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

## Setup

During the `get_started.sh` we have added all requirements for our hands on in this environment, `python` and `ansible`.

Together to facilitate we have added the following extensions:

```
Zowe - to verify the files we will be handling in ZXplore
Ansible - For highligh in our playbooks
indent-rainbow - To highlight identation
```

In the z/OS, all we need to have available is `python`, `Z Open Automation Utilities` and `OpenSSH`. The path for Python and ZOAU is already included on the inventory created by the get_started script.

## Our first play

Here we have already our first playbook to get started, the `ping.yaml` that will use the same module we have used together with adhoc command.

```
---
  - hosts: zxplore
    gather_facts: no
    tasks:
      - name: Testing connection with zxplore
        ansible.builtin.ping:
```

This playbook is pointing with what target host we are running these tasks against, and under the tasks we have only the `ping` module that allow us check our connection. To run that use `ansible-playbook -i inventory.yaml ping.yaml`

```
ansible-playbook -i inventory.yaml ping.yaml --key-file "./zxplore_id"

PLAY [zxplore] *********************************************************************************************************

TASK [Testing connection with zxplore] *********************************************************************************
ok: [zxplore]

PLAY RECAP *************************************************************************************************************
zxplore                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Adding our first collection

So let's explore the first z/OS module, adding our ibm_core_zos collections and playing with zos_copy:
https://ibm.github.io/z_ansible_collections_doc/ibm_zos_core/docs/source/modules/zos_copy.html

0- Install the zOS Collection with `ansible-galaxy collection install ibm.ibm_zos_core`

```
➜ ansible-galaxy collection install ibm.ibm_zos_core
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/download/ibm-ibm_zos_core-1.3.6.tar.gz to /Users/billpereira/.ansible/tmp/ansible-local-55435f0dcaql7/tmpw41xb2gb/ibm-ibm_zos_core-1.3.6-7nahtiht
Installing 'ibm.ibm_zos_core:1.3.6' to '/Users/billpereira/.ansible/collections/ansible_collections/ibm/ibm_zos_core'
ibm.ibm_zos_core:1.3.6 was installed successfully
```

1- Add the collection to the playbook and the zos environment vars.

```
  environment: "{{ environment_vars }}"
  collections:
    - ibm.ibm_zos_core
```

2- Add a task to copy content to a file in USS

```
    - name: "Copy from content to file"
      ibm.ibm_zos_core.zos_copy:
        content: "Hello World"
        dest: /z/z12309/hello_from_GSE
```

3- Add a task to copy content to a dataset

```
    - name: "Copy from content to dataset"
      ibm.ibm_zos_core.zos_copy:
        content: "Hello World"
        dest: Z12309.ANSB.HELLO.GSE
```

4- Lets now change it, Lets create a copy of our active IEASYS00 to USERID.ANSB.PARMLIB, first allocate the PDS with `zos_data_set` module.

```
    - name: "Allocate PEREIRW.ANSB.PARMLIB"
      ibm.ibm_zos_core.zos_data_set:
        name: Z12309.ANSB.PARMLIB
        type: PDS
        state: present
```

5- Copy SYS1.PARMLIB(IEASYS00) to USERID.ANSB.PARMLIB.

```
    - name: "COPY IEASYS00"
      ibm.ibm_zos_core.zos_copy:
        src: "LVL0.PARMLIB(IEASYS00)"
        dest: Z12309.ANSB.PARMLIB(IEASYS00)
        remote_src: true
```

## Variables

To make that re-usable we may want to have the member name as variable for example, or the dataset name. This is something we can do with variables/facts in the playbook in several ways.

The variables could be defined in the playbook under `vars`, we can have this also under specific task. It could be defined used `set_fact`, in the iventory, there are several ways, and based on how it is defined we have a precedence for them (the last listed variables override all other variables):

```
command line values (for example, -u my_user, these are not variables)
role defaults (defined in role/defaults/main.yml)
inventory file or script group vars
inventory group_vars/all
playbook group_vars/all
inventory group_vars/*
playbook group_vars/*
inventory file or script host vars
inventory host_vars/*
playbook host_vars/*
host facts / cached set_facts
play vars
play vars_prompt
play vars_files
role vars (defined in role/vars/main.yml)
block vars (only for tasks in block)
task vars (only for the task)
include_vars
set_facts / registered vars
role (and include_role) params
include params
extra vars (for example, -e "user=my_user")(always win precedence)
```

The variable can NOT be named starting with number, have `space`, `.` or `-`. Neither use python or playbook keywords.

1 - So now, instead of keeping your parmlib, the copy and the member hardcoded on the playbook, use as a variable defining them as `play vars`.

```
  vars:
    src_library: "LVL0.PARMLIB"
    target_library: "Z12309.ANSB.PARMLIB"
    member: "IEASYS00"
```

To reference that we will use Jinja2 format, including the var inside of double curly braces `{{ var_name }}`

https://jinja.palletsprojects.com/en/3.1.x/

2 - Now update your tasks:

```
---
- name: Creating a copy of parmlib member
  hosts: zxplore
  gather_facts: false
  environment: "{{ environment_vars }}"
  collections:
    - ibm.ibm_zos_core
  vars:
    src_library: "LVL0.PARMLIB"
    target_library: "Z12309.ANSB.PARMLIB"
    member: "IEASYS00"
  tasks:
    - name: "Allocate our parmlib copy dataset"
      ibm.ibm_zos_core.zos_data_set:
        name: "{{ target_library }}"
        type: PDS
        state: present

    - name: "COPY IEASYS00"
      ibm.ibm_zos_core.zos_copy:
        src: "{{ src_library }}({{ member }})"
        dest: "{{ target_library }}({{ member }})"
        remote_src: true

```

3- Let's now play with the `set_fact` option and `lookup` to read our `iplinfo` file, and take decisions based on this output. We are doing it instead of using the zos command cause we don't have authority to issue commands on this lpar.

```
    - name: Getting content of iplinfo file
      ansible.builtin.set_fact:
        iplinfo: "{{ lookup('file', 'iplinfo') }}"

```

Manipulate strings is very useful tool, for example we could take from thee facts information about current columes to prepare a whole process for alternates volumes. To practice let's use `regex_findall`.

4 - Use `set_fact` and `regex_findall` to get the IPL Address from our IPLINFO output. To display your results use `debug` module

```
    - name: Find IPL Address
      ansible.builtin.set_fact:
        ipladdress: "{{ iplinfo | regex_findall('(IPL DEVICE: ORIGINAL\\()(.*?)\\)') }}"
```

5 - To complete it let's use this variable in a message to display the IPL DEVICE:

```
    - name: Find IPL Address
      ansible.builtin.set_fact:
        ipladdress: "{{ iplinfo | regex_findall('(IPL DEVICE: ORIGINAL\\()(.*?)\\)') }}"

    - name: Displaying var
      ansible.builtin.debug:
        msg: "The last IPL was on address {{ ipladdress[0][1] }}"


TASK [Getting content of iplinfo file] *********************************************************************************
ok: [zxplore]

TASK [Find IPL Address] ************************************************************************************************
ok: [zxplore]

TASK [Displaying var] **************************************************************************************************
ok: [zxplore] => {
    "msg": "The last IPL was on address 01000"
}

PLAY RECAP *************************************************************************************************************
zxplore                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Looping and Conditions

We also have the habilities as in other programming languages, to work with loops and conditions.

To get started let's create a PDS `USERID.ANSB.JCL` and add this 2 JCLs:

```
JOB1
//JCL1    JOB 1
//***************************************************/
//HELLO  EXEC PGM=IEFBR14


JOB2
//JCL1    JOB 1
//***************************************************/
//HELLO  EXEC PGM=IEFBR14

```

Now let's imagine we just want to run these 2 jobs in case a specific task, `ZWE1AC` is NOT up.

We could `zos_operator` to display all active tasks and register in `active_tasks` variable, but as we don't have access to issue commands, let's have it like task before reading from active_tasks file.

```
    - name: "Checking active tasks"
      ibm.ibm_zos_core.zos_operator:
        cmd: D A,L
      register: active_tasks
```

1 - Set the variables `task_to_search` that we want, and `active_tasks` to hold the results of the command

```
    - name: Setting variables
      ansible.builtin.set_fact:
        active_tasks: "{{ lookup('file', 'active_tasks') }}"
        task_to_search: ZWE1AC
```

Now to evaluate a condition we are going to use `when`, it let us work with traditional operators, example `==`, `>`... and also with other special operators, example `in`, `not in` like in python.

So it allow us to use the following condition to submit or not our jobs:

```
when: task_to_search in command_result
```

3 - Now we can use the `zos_job_submit` to submit our JCLs. There are different manners for that, we will play with `with_items`. This execute our task for each item on the list.

```
    - name: Submitting maintenance jobs
      ibm.ibm_zos_core.zos_job_submit:
        src: "{{ item.dsn }}({{ item.member }})"
        location: DATA_SET
        wait: true
        return_output: true
        max_rc: 0
      loop:
        - dsn: Z12309.ANSB.JCL
          member: JOB1
        - dsn: Z12309.ANSB.JCL
          member: JOB2
      when: task_to_search not in active_tasks
```

> Challenge - What if you create a block for executing your jobs and print a message that it's happening or print a message if it's not and task is active?

## Templating

Templating is another useful function we can make use. On previous task we have submitted some jobs, but if these jobs need to be customized before we submit them?

Let's put our IEFBR14 jobs to allocate some datasets.

Ansible has the builtin `template` module that let us work with Jinja2 Templating.

So let's create our `job14.j2` to allocate a dataset using a variable for the DSNAME to allocate Z12309.ANSB.DSN1.

```
iefbr14.j2
//JCL14   JOB 1
//***************************************************/
//HELLO   EXEC PGM=IEFBR14
//DSN1    DD DSN={{dsname}}1,
//        DISP=(NEW,CATLG),
//        UNIT=SYSALLDA,
//        SPACE=(TRK,1)
```

Inside of the `.j2` file we use the same notation as in the playbook, using the `{{}}` to point a variable. And we can perform multiple operations, conditions, loop, following the same format we have seen, the `Jinja2`.

So let's how the template module works:

```
    - name: Prepare our job
      ansible.builtin.template:
        src: job14.j2
        dest: ./job14.jcl
      delegate_to: localhost
```

In the `src` we have the location where the template is on tontrol node, and on the `dest` where the results will be saved on target host.
Just a last exercise with the templating, let's add multiple DD fields so we can pass a list of datasets from the playbook to be allocated.

So on our playbook, we will create a variable `datasets_to_be_allocated` that will be a list containing `ddname` and `dsname` for our template.

```
    - name: "Preparing for our tests"
      set_fact:
        datasets_to_be_allocated:
          - ddname: JCL
            dsname: Z12309.ANSB.JCL
          - ddname: REXX
            dsname: Z12309.ANSB.REXX
```

On the template we will have the `DD` statement in a for block:

```
{% for variable in list %}

{% endfor %}
```

So our template will be:

```
//JOB14 JOB (ACCT),'BR14 JOB',CLASS=A,
//  REGION=64M,MSGCLASS=X,MSGLEVEL=(1,1),
//  NOTIFY=&SYSUID
//****
//*
//****
//*
//HELLO EXEC PGM=IEFBR14
{% for dataset in datasets_to_be_allocated %}
//{{dataset.ddname}}  DD DSN={{dataset.dsname}},
//      DISP=(NEW,CATLG),
//      UNIT=SYSALLDA,
//      SPACE=(TRK,1)
{% endfor %}
```

## Restarting activities on ZXplorer

If you want to restart the hands on activities on the lpar use `restart.yaml` It will delete the jcls generated from template, datasets and files allocated on the lpar.
