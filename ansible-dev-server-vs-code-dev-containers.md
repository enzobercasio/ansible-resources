# Ansible Dev Server using VSCode Dev Containers 

## About Dev Containers 

A **Dev Container** is a preconfigured, isolated development environment that runs inside a container, providing all the tools, libraries and dependencies you will need for a specific development project. Instead of setting up your local machine, you will define the environment once (using devcontainer.json) file and anyone on your team can spin up an identical setup instantly. 

In VS Code, this is implemented through ther Dev Containers extension. This extension lets VS Code connect directly to a container as your development environment. When you open a folder with a *devcontainer.json* file, VS Code automatically builds the container, install the dependencies and attaches your editor to it. 

For Ansible Playbook or Content Creation, this means you can have all the Ansible Development Tools (ADT) such as ansible-core, ansible-lint, ansible-navigator and any required collections or Python libraries preinstalled in the container. Your team can immediately start writing, linting, testing and running playbooks in a consistent reproducible environment - without worrying about local setup or version mismatches. 
___
### What are the benefits?
- No external setup - runs completely on your workstation 
     - Requires podman/docker (and WSL if on Windows) 
         - On podman, works best with machine without root privileges 
     - Requires access to registry.redhat.io 
     - Requires access to your Automation Hub if using custom EE 
- Complete **ansible-dev-tools** included 
     - Includes *ansible-core*,ansible-builder, ansible-creator, ansible-lint, ansible-navigator, ansible-sign, ansible-molecule, pytest-ansible, tox-ansible, ansible-dev-environment*
- Can fully use the Ansible Extensions including EEs and Ansible Lightspeed

___
### Dev Containers Extension Prerequsities and Set Up

### Prerequisites:
- Podman, Podman Desktop, Docker or Docker Desktop
- Red Hat login to Red Hat registry (registry.redhat.io) and/or to the Private Automation Hub
- Installed VSCode
- Installed Ansible Extension in VSCode
- Installed Microsoft Dev Containers in VSCode 
- If installing on Windows, launch VSCode and connect to the WSL machine  

### If using Podman
1. Replace docker with podman in the Dev Containers extension settings: 

   In VSCode, open the settings editor.

   - Search for **_@ext:ms-vscode-remote.remote-containers_**

   Alternatively, click the extensions icon in the activity bar and click the gear icon for the Dev Containers extension.

   - Set Dev > Containers: Docker Path to **podman**
   - Set Dev > Containers: Docker Compose Path to **podman-compose**

### Set Up Podman Desktop

1. Create Podman machine
2. Add Registry registry.redhat.io 

___
## Installing Ansible Development Tools (ADT) on a container inside VS Code 

1. In VS Code, go to your project directory.
2. Go to the Ansible Extension (click Ansible icon)
3. In the **Ansible Development Tool**, select **Devcontainer**
4. In the **Create a devcontainer** page, select the **Downstream** container image from the options. 
    - a **_devcontainer.json_** file will be created in your project directory. This contains the settings for your dev container. 
![Ansible Development Tool](/img/ansible-dev-server-vs-code/img-02.png)

5. Click Open Devcontainer
    - A notification to **Reopen in container** will appear once VS Code detects the **_devcontainer.json_** file. 
    - Click **Reopen in Container**
![](/img/ansible-dev-server-vs-code/img-03.png)

6. Select the dev container for Podman or Docker depending on which platform you are using. 
![](/img/ansible-dev-server-vs-code/img-04.png)
7. Once the directory reopens in a container, the Remote () status displays *Dev Container: ansible-dev-container*. 
![](/img/ansible-dev-server-vs-code/img-06.png)
8. You can now start developing Ansible content inside the dev container. 
![](/img/ansible-dev-server-vs-code/img-05.png)
9. Verify that the Ansible Development Tools and some Collections are already installed. 
![](/img/ansible-dev-server-vs-code/img-08.png)
___
Reference: [Installing Ansible development tools on a container inside VS Code](https://docs.redhat.com/fr/documentation/red_hat_ansible_automation_platform/2.4/html-single/developing_ansible_automation_content/index#devtools-install-container_installing-devtools)

