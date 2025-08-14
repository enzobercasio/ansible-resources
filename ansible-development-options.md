# Ansible Development Environment Options 

## Benefits of Setting Up Ansible Development Environment

- Creating an Ansible Development Environment streamlines automation content creation by providing a consistent, preconfigured workspace equipped with all necessary tools, libraries, and dependencies. 
- Eliminates “works on my machine” issues, ensuring that playbooks and roles behave the same across local, staging, and production environments. 
- Enhances productivity by integrating linting, testing, and debugging into the workflow, reducing errors before deployment. 
- Fosters collaboration by enabling developers to share identical environments—whether through containers, remote servers, or dev workspaces—ensuring predictable results and easier onboarding for new team members. 
- Accelerates delivery but also improves the overall quality, maintainability, and reliability of automation code.

## Local Development Options 

Local setups are ideal if you want direct control over the environment, low-latency editing and offline capabilities. 

1. **Python Virtual Environment**

    A Python Virtual Environment (venv) allows you to isolate your Ansible dependencies without affecting your system-wide Python installation.

    **Benefits:**
    - Lightweight and fast to set up.
    - Perfect for working on multiple projects with different Ansible versions.
    - Avoids dependency conflicts with other Python projects.

    **Typical Workflow:**

    ```
    python3 -m venv ansible-venv
    source ansible-venv/bin/activate
    pip install ansible ansible-lint
    ```

    **Best for:** Developers who prefer simplicity and minimal tooling overhead. 


2. **Docker/Podman Desktop**
    
    Running Ansible inside a container ensures a fully reproducible and clean environment every time.

    **Benefits:**
    - Consistent environment across development machines.
    - Easy to reset or switch between configurations.
    - Ideal for integrating with CI/CD pipelines.

    **Best for:** Teams needing consistent builds and isolated environments without polluting local systems.
    
    see [Ansible Dev Server using VS Code Dev Containers](https://github.com/enzobercasio/ansible-resources/blob/master/ansible-dev-server-vs-code-dev-containers.md)

---
## Remote Development Options 

Remote setups are ideal for collaborative work, resource-heavy tasks, and when you need a consistent environment accessible from anywhere. 


3. **Code Server**

    Code Server runs Visual Studio Code in a browser, allowing you to connect to a remote Ansible-ready environment. 

    **Benefits:** 
    - Access from any device with a browser
    - No laptop installation required
    - Same VS Code extensions and settings everywhere
    - Easy to share environments with teammates

    **Best for:** Distributed teams that want a familiar IDE in a cloud-accessible form. 

    see [Ansible Dev Server Using Code Server](https://github.com/enzobercasio/ansible-resources/blob/master/ansible-dev-server.md)


4. **Remote SSH**

    With VS Code Remote SSH, you connect to a remote server or VM where Ansible is installed. 

    **Benefits:**
    - Full control over a powerful remote machine 
    - Leverage remote compute resourcces while keeping local machine lightweight
    - Minimal setup if SSH access is already available 
    - Utilize all Ansible extension capabilities including Lightspeed

    **Best for:** Developer who want low-latency terminal performance but remote compute power. 

    see [Ansible Dev Server using VS Code Remote SSH](https://github.com/enzobercasio/ansible-resources/blob/master/ansible-dev-server-vs-code-remote-ssh.md)

5. **OpenShift Dev Spaces**

    OpenShift Dev Spaces provides a cloud-based, containerized development environment integrated directly with OpenShift. 

    **Benefits:** 
    - Preconfigured, on-demand development workspaces with Ansible tools
    - Integration with GitOps and CI/CD Workflows 

    **Best for:** Teams already working in an OpenShift ecosystem who want a fully managed, enterprise-ready dev platform.

---
## Recommendations
- If using Option 2, use the [VS Code with Ansible and Dev Containers Extensions](https://github.com/enzobercasio/ansible-resources/blob/master/ansible-dev-server-vs-code-dev-containers.md) approach.
- You can use hybrid approach. For example, prototyping locally in a container [option 2] and then test playbooks in an OpenShift Dev Spaces workspace [option 5] before committing to production. Or use Development Server with Remote SSH [option 4] and configure the VS Code in server to always use Dev Containers [option 2]
- [Automate Ansible Dev Server provisioning with Ansible](https://github.com/enzobercasio/ansible-resources/tree/master/ansible-dev-server)

