

# Ansible / AAP Commands Cheat Sheet

### Core CLI

```
ansible --version                # show versions, config paths, collections path
ansible-config view              # view effective config
ansible-config list              # all options (with defaults & docs)
ansible-config dump --only-changed
ansible-doc -l                   # list modules/plugins
ansible-doc ansible.builtin.copy # docs for a module
ansible-inventory -i inventory/hosts.yml --list  # expand inventory
ansible-inventory -i inventory/hosts.yml --graph # graph view
ansible -i hosts all -m ping     # ad-hoc module run
ansible -i hosts web -m shell -a "uptime"
ansible-playbook -i hosts site.yml        # run a playbook
ansible-playbook site.yml --check --diff  # dry run with diffs
ansible-playbook site.yml -t web -l prod  # limit by tag & host/group
ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook site.yml  # nicer output
```

### Runtime Flags

```
-v / -vv / -vvv          # verbosity
--start-at-task "NAME"   # resume from a task
--step                   # confirm each task before running
--limit host1,group1     # limit to subset of inventory
--tags web --skip-tags db
--extra-vars "key=val"   # or -e @vars.json
--forks 25               # parallelism
--timeout 60             # SSH timeout
```

### Inventory and Patterns

```
ansible -i hosts 'web:&prod:!deprecated' -m ping
ansible-inventory -i hosts --yaml --host app01
```

### Vault
```
ansible-vault create group_vars/prod/secret.yml
ansible-vault edit   group_vars/prod/secret.yml
ansible-vault view   group_vars/prod/secret.yml
ansible-vault encrypt files/*.yml
ansible-vault decrypt files/*.yml
ansible-playbook site.yml --ask-vault-pass
ansible-playbook site.yml --vault-password-file .vault-pass
# Vault IDs (multiple vaults):
ansible-playbook site.yml --vault-id dev@prompt --vault-id prod@.vault-pass
```

### Collections and Roles

```
ansible-galaxy collection search kubernetes
ansible-galaxy collection install kubernetes.core:==3.0.1
ansible-galaxy collection list
ansible-galaxy role init myorg.myrole
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install -r collections/requirements.yml
```

### Linting and Testing
```
ansible-lint                      # lint current project
ansible-lint playbooks/site.yml
molecule init role myrole -d docker
molecule test                    # create → converge → verify → destroy
```

### Ansible Navigator 
```
ansible-navigator run playbooks/site.yml -i inventory/ --mode stdout
ansible-navigator run playbooks/site.yml -i inventory/ -e @vars.yml -t web
ansible-navigator collections           # browse installed collections
ansible-navigator doc ansible.builtin.copy  # module docs UI/JSON
ansible-navigator inventory -i hosts --list # inspect inventory
# Use a specific Execution Environment (EE):
ansible-navigator run site.yml -i hosts --execution-environment true \
  --container-engine podman \
  --eei quay.io/ansible/creator-ee:latest
```

### Ansible Builder (Execution Environments)
```
# 1) Create definition
cat > execution-environment.yml <<'YML'
version: 3
images:
  base_image:
    name: quay.io/ansible/ansible-runner:stable-3
dependencies:
  galaxy: requirements.yml
  python: requirements.txt
YML

# 2) Build & push EE
ansible-builder build -t quay.io/yourorg/ee:latest -f execution-environment.yml
podman login quay.io
podman push quay.io/yourorg/ee:latest
```
