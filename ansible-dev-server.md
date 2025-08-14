# Ansible Dev Server Using Code Server

### Why use Code Server for Ansible Development

[Code Server](https://code.visualstudio.com/docs/remote/vscode-server) is an open-source project that lets you run Visual Studio Code on a remote server and access it via a web browser. This means you can have a fully configured Ansible development environment available anywhere, on any device.

### Key Benefits
- **Work Anywhere:** Just open a browser and login. 
- **Consistent Environment:** Every developer works in the same set up. 
- **Minimal Local Requirements:** No local installation, only access via browser. 
- **Centralized Management:** Easy to update and secure in one place. 

### Architecture Overview 
The setup involves: 

1. A remote server (VM or EC2) running Code Server. 
2. Ansible Development Tools installed in the server environment. 
3. Browser Access with authentication and HTTPS for security (for this demo, we will not use HTTPS)

![Ansible Development Server](/img/ansible-dev-server/img-00.png)

### Prerequisites 
- A linux-based server or cloud instance (e.g. AWS EC2 or on-prem VM)
- Docker or Podman installed (optional but recommended for containerized development)
- Required port for Code Server access is accessible (e.g add 8080 in Security Group for AWS EC2)
- Domain name (optional) for secure HTTPS access

### Install Code Server in Server

1. Download and install Code Server

    ```
    curl -fsSL https://code-server.dev/install.sh | sh
    ```

2. Start Code Server
    
    To run in background
    ```
    sudo systemctl enable --now code-server@ubuntu
    ```
     
    Or if you don't want a background service to run
    ```
    code-server
    ```

    ![Ansible Development Server](/img/ansible-dev-server/img-01.png)
  

3. Configure password authentication, edit **_~/.config/code-server/config.yaml_**

    ```
    bind-addr: 0.0.0.0:8080
    auth: password
    password: your-secure-password
    ```

4. Restart Code Server
    
    To run in background
    ```
    sudo systemctl daemon-reload
    sudo systemctl restart code-server@ubuntu
    ```
     
    Or if you don't want a background service to run
    ```
    code-server
    ```

    ![Ansible Development Server](/img/ansible-dev-server/img-01.png)

5. Access in Browser, visit **_http://your-server-ip:8080_**
   
    Login using the password previously set in the config file. 
    ![Ansible Development Server](/img/ansible-dev-server/img-02.png)

    Visual Studio Code Workspace from Remote Code Server
    ![Ansible Development Server](/img/ansible-dev-server/img-03.png)

6. Install ansible-navigator 

    ```
    sudo apt install python3-pip
    pip install ansible-navigator --user
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.profile
    source ~/.profile
    ```

7. Install podman and git

    ```
    sudo apt install podman
    sudo apt install git
    podman --version
    git --version
    ```

8. Deploy base ansible settings

    In VS Code, go to Settings, type in **_@ext:redhat.ansible_**
    - You can enable Execution Environment
    - Change the container engine (Docker or Podman), for our case we will use podman
    - Add the Execution Environment Image 

    ![Ansible Development Server](/img/ansible-dev-server/img-04.png)

9. Add ansible extension

    ```
    code-server --install-extension redhat.ansible
    ```
    To see the list of installed extensions
    ```
    code-server --list-extensions
    ```
    To find the code to use for other extensions, refer to [VS Code Marketplace](https://marketplace.visualstudio.com/vscode)

10. Clone sample playbook and test run

    ```
    git clone https://github.com/enzobercasio/ansible-demo.git
    ```
    ![Ansible Development Server](/img/ansible-dev-server/img-05.png)


### Recommendations
- Use HTTPS in production 
- Use strong authentication 
- Restrict access to trusted IPs when possible
- Keep your Code Server instance updated
- [Automate Ansible Dev Server with Ansible](https://github.com/enzobercasio/ansible-resources/tree/master/ansible-dev-server)
- Refer to official [VS Code - Code Server documentation](https://code.visualstudio.com/docs/remote/vscode-server) for licensing and other FAQs.

### Additional settings 

For Podman additional user

```
sudo vi /etc/subuid
sudo vi /etc/subgid 
sudo podman system migrate
```