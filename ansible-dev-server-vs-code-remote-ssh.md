# Ansible Dev Server using VSCode Remote SSH 

### Why USe Remote SSH for Ansible Development?
When developing Ansible playbooks, you might want to: 
- Keep all dependencies on a central development server. 
- Avoid installing Ansible tools locally.
- Work from multiple devices without reconfiguring each one.
- Access servers in secure or restricted environments. 

[Remote SSH](https://code.visualstudio.com/docs/remote/ssh) in VS Code allows you to connec to a remote machine and use it as your development environment as if it were local. 

### Prerequisites 
- **Remote Development Server** (Linux, with SSH enabled)
- **VS Code** installed on your local machine 
- SSH key-based authentication configured between your local machine and the remote server. 

---
### Setup
1. Install the Remote SSH Extension in VS Code 
  -  Open VS Code.
  -  Go to **Extensions** 
  -  Search for **Remote - SSH** and install it.

  ![Ansible Development Server with Remote SSH](/img/ansible-dev-ssh/img-01.png)

2. Configure SSH connection
  - Edit your local `~/.ssh/config` file:
    ```
    Host ansible-dev
        HostName 203.0.113.10
        User devuser
        IdentityFile ~/.ssh/id_rsa
    ```

3. Connect from VS Code 
  - Press F1, type in **Remote-SSH: Connect to Host...**
  - Select **_ansible-dev_**
  - Or go to the **Remote Explorer** and click on the remote server from the SSH list

  ![Ansible Development Server with Remote SSH](/img/ansible-dev-ssh/img-03.png)

4. Set Up your Ansible Remote Workspace
  - Once connected, instrall VS Code extensions **in the remote environment**
    - Red Hat Ansible 
    - Dev Containers 

    ![Ansible Development Server with Remote SSH](/img/ansible-dev-ssh/img-02.png)

    or via the terminal 
    ```
    code-server --install-extension redhat.ansible
    ```

  - Install Podman (for container execution)
  - Git 

    ```
    sudo apt install podman
    sudo apt install git
    podman --version
    git --version
    ```

  - Ansible-Navigator

    ```
    sudo apt install python3-pip
    pip install ansible-navigator --user
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.profile
    source ~/.profile
    ```

5. Test playbook run

    ```
    git clone https://github.com/enzobercasio/ansible-demo.git
    ```

    ![Ansible Development Server with Remote SSH](/img/ansible-dev-ssh/img-04.png)