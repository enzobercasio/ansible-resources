### To run 
Update vars/group vars before running

```
ansible-playbook -i inventories/dev/hosts.ini -l local playbooks/create_ec2.yml
ansible-playbook -i inventories/dev/hosts.ini -l devhost playbooks/bootstrap_user_dev.yml
```

