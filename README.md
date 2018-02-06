# HarmonicIOSetup
Ansible playbooks for installing and starting Harmonic IO on a virtual environment.

# Installation and setup

The setup requires an working ansible environment with VMs available to deploy HIO workers 

Run the install_ansible script to install ansible then edit the hosts file with the IPs to your workers and add more workers if necessary.

Ports for the master and workers can be edited inside the `deployHIO.yml` script


Run an ad-hoc command on all hosts to test SSH connectivity:
```
ansible -i hosts workers:master -a "echo hi!"
```

Run the deployHIO playbook to install HarmonicIO:
```
ansible-playbook -i hosts playbooks/deployHIO.yml
```

Start HarmonicIO:
```
ansible-playbook -i hosts playbooks/startMasterWorker.yml
```

Check if HarmonicIO is running (by checking for screen sessions):
```
ansible --become-user root -i hosts workers:master -a "screen -ls"
```

...by checking for the listening ports (8888 and 8080):
```
ansible -i hosts workers:master -a "sh -c 'netstat --numeric --listening --tcp | grep --line-buffered --extended \"(8080|8888)\"'"
```

Stop HarmonicIO:
```
ansible-playbook -i hosts playbooks/stopMasterWorker.yml
```


# Send containers to Worker

```
curl -X POST "http://<private_IP_of_worker>:<port>/docker?token=None&command=create" --data '{"c_name" : "Container_name", "num" : 0}'
```