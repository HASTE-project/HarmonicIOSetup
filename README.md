# HarmonicIOSetup
Ansible playbooks for installing and starting Harmonic IO on a virtual environment.

# Installation and setup

The setup requires an working ansible environment with VMs available to deploy HIO workers 

Run the install_ansible script to install ansible then edit the hosts file with the IPs to your workers and add more workers if necessary.

Ports for the master and workers can be edited inside the `deployHIO.yml` script


For the HPC2N production pipeline, use:
```
-i hosts_HPC2N-haste-prod
```

* Run an ad-hoc command on all hosts to test SSH connectivity:

```
ansible -i hosts_HPC2N-haste-prod all -a "echo hi"
```

**Note: The deployment playbook will automatically start HarmonicIO master & workers**

* Run the deployHIO playbook to install HarmonicIO:

```
ansible-playbook -i hosts_HPC2N-haste-prod playbooks/deployHIO.yml
```

---

**Note: Run the following only when manual intervention is deemed necessary**

* Start HarmonicIO:

```
ansible-playbook -i hosts_HPC2N-haste-prod playbooks/startMasterWorker.yml
```

* Stop, Start & Verify Harmomic IO:

```
ansible-playbook -i hosts_HPC2N-haste-prod playbooks/stopMasterWorker.yml ; ansible-playbook -i hosts_HPC2N-haste-prod playbooks/startMasterWorker.yml ; ansible -i hosts_HPC2N-haste-prod workers:master -a "sh -c 'netstat --numeric --listening --tcp | grep --line-buffered --extended \"(8080|8888)\"'"
```

* Check if HarmonicIO is running, by checking for the listening ports (8888 and 8080):

```
ansible -i hosts_HPC2N-haste-prod workers:master -a "sh -c 'netstat --numeric --listening --tcp | grep --line-buffered --extended \"(8080|8888)\"'"
```
* ...see what containers are running

```
ansible -i hosts_HPC2N-haste-prod --become workers -a "docker ps"
```

* Stop HarmonicIO:

```
ansible-playbook -i hosts_HPC2N-haste-prod playbooks/stopMasterWorker.yml
```
---

# Send containers to Worker

```
curl -X POST "http://<private_IP_of_worker>:<port>/docker?token=None&command=create" --data '{"c_name" : "Container_name", "num" : 0}'
```

---

# Ad-hoc commands to start, stop, restart, verify supervisor child processes [ harmonicio_master ; harmonicio_worker ]

* Start

```
ansible -i hosts_HPC2N-haste-prod master -a "sudo supervisorctl start harmonic_master"
```
```
ansible -i hosts_HPC2N-haste-prod workers -a "sudo supervisorctl start harmonic_worker"
```

* Stop

```
ansible -i hosts_HPC2N-haste-prod master -a "sudo supervisorctl stop harmonic_master"
```
```
ansible -i hosts_HPC2N-haste-prod workers -a "sudo supervisorctl stop harmonic_worker"
```

* Restart

```
ansible -i hosts_HPC2N-haste-prod master -a "sudo supervisorctl restart harmonic_master"
```
```
ansible -i hosts_HPC2N-haste-prod workers -a "sudo supervisorctl restart harmonic_worker"
```

* Verify (check status)

```
ansible -i hosts_HPC2N-haste-prod master:workers -a "sudo supervisorctl status"
```
