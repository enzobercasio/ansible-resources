## Sample Ansible Automation to set up Ansible Dev - Code Server
### To run 
Update vars/group vars before running

Create EC2 instance to serve as Dev Server:
```
ansible-playbook -i inventories/dev/hosts.ini -l local playbooks/create_ec2.yml
```

Bootstrap EC2 Server 
```
ansible-playbook -i inventories/dev/hosts.ini -l devhost playbooks/bootstrap_user_dev.yml
```