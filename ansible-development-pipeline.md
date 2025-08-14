# Sample End-to-End Ansible Development Pileline
[this is work in progress]

### Target Architecture 

1. Local Development (VS Code Dev Container) - Lint and Unit/Syntax Checks and Local Containerized Playbook Run 
2. Molecule Functional Tests
3. Build EE with ansible-builder 
4. Scan and Sign EE - Push to Registry 
5. Publish Collections to Private Automation Hub
6. AAP-as-Code: sync projects, inventories, credentials, templates
7. Run Smoke in Test Inventory
8. Approval Gate
9. Promote via AAP Workflow Staging to Prod 
10. Monitoring and Reporting 

### Repos and Branch Model 

Use two repos (clean separation of concerns):

```
ansible-content/                    # your roles, playbooks, collections
├── collections/
│   └── ansible_collections/<namespace>/<name>/
│       ├── roles/...              # role code
│       ├── playbooks/...          # orchestration playbooks
│       ├── plugins/...            # filters, modules (if any)
│       ├── docs/
│       ├── galaxy.yml             # collection metadata (versioning!)
│       └── tests/                 # smoke tests, shared fixtures
├── requirements.yml               # external collections
├── execution-environment.yml      # ansible-builder spec
├── molecule/                      # suite-level functional tests for playbooks
│   └── default/...
├── .ansible-lint
├── .pre-commit-config.yaml
└── .github/workflows/ci.yml       # (or gitlab/azure pipelines)

aap-config/                         # AAP as Code (idempotent)
├── inventory/                      # controller host(s) if using direct modules
├── group_vars/all.yml              # AAP connection vars
├── projects.yml                    # controller_project definitions
├── inventories.yml                 # controller_inventory + groups/hosts
├── credentials.yml                 # controller_credential
├── templates.yml                   # controller_job_template
├── workflow.yml                    # controller_workflow_job_template + nodes
└── site.yml                        # includes the above; single entrypoint
```

Branching: 
- feature/* -> PR -> main
- main -> builds EE, run functional tests, publishes to Private Automation Hub and run smoke tests in Test
- Promotion to Staging/Prod is via AAP Workflow 


