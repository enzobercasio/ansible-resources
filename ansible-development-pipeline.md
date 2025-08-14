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


