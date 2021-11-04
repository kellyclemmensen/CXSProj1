## Document Topics
- Automated ELK Stack Deployment
  - Azure Build
  - Access Policies
  - DVWA Configuration
  - ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- Cybersecurity Bootcamp Scripts
- Kibana Investigation Summary
- How to Use the Ansible Build

## Automated ELK Stack Deployment

### Overview
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.
ELK Stack is implemented for the purposes of doing investigation into log and system module activity. This implementation leverages Infrastructure as a Service (IAAS) to build the environment in which DVWA web sites and the ELK stack implement is built on. 

This document describes the environment built and tasks completed, in sequence to fully implement a working environment.

### Azure Build
This environment was built using Microsoft Azure cloud hosting. A trial account with a $200 credit was opened and used for this project. 

#### Azure Components Table
The table below lists Azure components deployed in the Azure environment to support the ELK Stack environment and their descriptions. 
| Azure Component     | Description |
|----------|----------|
| Resource Group | A resource group is a container that holds related resources for an Azure solution.  |
| Virtual Network | Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources to securely communicate with each other, the internet, and on-premises networks. |
| Subnets     |  A subnet is a range of IP addresses in the virtual network.      | 
| Network Security Groups     |  Network Security Groups provide control over network traffic flowing in and out of your services running in Azure.     | 
|  Virtual Machines    |    On Demand, scalable computing resources   | 
|  Load Balancer   |    Load balancing ensures that the application will be highly available, in addition to restricting access to the network. Load balancers serve multiple purposes. At their core, LBs distribute traffic between configured backend workloads. They verify health state of backend workloads and make sure they are online before sending traffic. From the aspect of security, LBs prevent access directly to backend resource, adding a layer of control over access to the backend resource. | 
|  Public IP Address   |    Public IP addresses enable Azure resources to communicate to Internet and public-facing Azure services | 
|  Availability Set   |    An availability set is a logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability.   | 

#### Virtual Network and Subnet
The table below lists the virtual networks and subnets for each created to host the virtual machine environment
| Virtual Network    | IP Address Space | Subnets | Resource Group | Region | 
|----------|----------|------------|------------|------------|
| WUS2-VNET | 10.2.0.0/16  | 10.2.0.0/24 | RedTeam_RG | West US 2 |
| EUS-VNET | 10.10.0.0/16 | 10.10.0.0/24 | RedTeam_RG | East US |

#### Virtual Machines
The table below lists the virtual machines built, including roles and specifications of each. 
| Name     | Role | IP Address | Operating System | vCPU | Memory | Size | 
|----------|----------|------------|------------------|------------------|------------------|------------------|
| Jump-Provisioner | Gateway/Ansible Controller  | 10.2.0.4   | Linux  | 1 | 1GB | Standard B1s |
| Web-01     |  Web Server        | 10.2.0.5          | Linux        |  1 | 2GB | Standard B1ms | 
| Web-02     |  Web Server        | 10.2.0.6          | Linux        |   1 | 2GB |    Standard B1ms | 
| Web-03     |  Web Server        | 10.2.0.7          | Linux        | 1 | 2GB |  Standard B1ms | 
| ELK-01     | ELK Stack Server   | 10.10.0.4         | Linux      | 2 | 4GB | Standard B2ms | 

The Jump-Provisioner virtual machine's role/function is for administration of the virtual machines inside the Azure virtual environment. This machine will allow connections from public sources via SSH protocol. This server will host the Ansible Controller.

The 3 Web servers will be used to host the DVWA web site. These servers will be setup in an availability set and a load balancer will be setup in front of these web servers to distribute traffic to each web server virtual machine. 

The Elk server will be used to host the ELK stack. It is important that the size of the VM has at least 2vCPU and 4GB of memory. The ELK stack will not work with a virtual machine that has less than 4GB of memory.

#### Network Security Groups | Access Policies

The machines on the internal network are not exposed to the public Internet. Only the Jump-Provisioner machine can accept connections from the Internet. The load balancer in front of the Web hosts, is configured with a public IP address and access is restricted to a specific source and destination port.

A summary of the access policies of the build can be found in the table below.

| Name  | Publicly Accessible  | Allowed IP Addresses  | Port  |
|---|---|---|---|
|  Jump-Provisioner | Yes  | 73.45.45.20  | 22  |
| Elk-01  | Yes  | 73.45.45.20  | 5601  | 
| Web Servers | Yes | 73.45.45.20 | 80 |

#### Azure Diagram
Diagram location: [Azure Diagram](https://github.com/kellyclemmensen/CXSProj1/blob/main/Diagrams/Project1-AzureBuildOut.png)


### Ansible and DVWA Implementations

#### Overview
From dvwa.co.uk - "Damn Vulnerable Web App (DVWA) is a PHP/MySQL web application that is damn vulnerable. Its main goals are to be an aid for security professionals to test their skills and tools in a legal environment, help web developers better understand the processes of securing web applications and aid teachers/students to teach/learn web application security in a class room environment"

The high level actions and files in the following section detail the steps I took to install the Ansible docker and bring up a working DVWA web site on each of the 3 Web servers. 

#### Ansbile Docker Container Installation
From Wikipedia - "Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows."

Ansible (Controller) was deployed to the Jump-Provisioner server @ 10.1.0.4. This controller will then be used to install docker and the DVWA container to each of the web servers.

Tasks performed from the Jump-Provisioner server to install the Docker.IO. 
- Login to the Jump-Provisioner server via SSH
- Install Docker.IO 
  - run command "sudo apt update"
  - run command "sudo apt install docker.io"
  - Verify the Docker service is running. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/AnsibleServiceRunning.png)

Tasks performed from the Jump-Provisioner server to setup the Ansible container.
- From the Jump-Provisioner server, run command "sudo docker pull cyberxsecurity/ansible". This command pulls the Ansible container down to the local Docker service
- Launch the Ansible container and connect to it
  - Command - "sudo docker run -ti cyberxsecurity/ansible:latest bash". Note: This command creates an instance of Ansible container. It only needs to be run once.
  - Ansible container does not run after a server reboot. 
    - Command - "sudo docker start CONTAINER_NAME" will start the container
    - Command - "sudo docker attach CONTAINER_NAME" will attach to the running Ansible container.
- Verify the Ansible container is running. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/AnsibleContainerRunning.png)

In order for the Ansible container to have the ability to push out Docker and the DVWA container, SSH keys need to be generated from the Ansible container, which are then used to update each of the Web server virtual machines from the Azure console. 

These are the tasks performed to replace the existing SSH keys
- From the Jump-Provisioner server, generate new SSH keys
- Copy the public Key detail from the generated SSH Key
- In the Azure portal, navigate to the virtual machine > Reset Password pane. Update the SSH public key information with the new SSH key information you created. Update the virtual machine. Repeat SSH replace tasks for each Web Server. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/AzureSSHKey.png)
- Verify SSH access to each Web server from the Ansible container. 

#### DVWA Web VM with Docker Installation

Ansible and the Web Servers are now ready to install the DVWA Docker container.

I updated the /etc/ansible/hosts configuration file to add/update the WebServers section and include the IP addresses of the Web server hosts. 
Tasks performed: 
- Edited /etc/ansible/hosts
- Updated the [WebServers] section of the configuration file. 
  - Add the IP address of each Web server. Appended "ansible_python_interpreter=/usr/bin/python3" next to the IP address of each Web server.
  - [Screen shot of Ansible hosts file WebServers section](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/AnsibleHosts.png)
- Verified that the Ansible "controller" can communicate and access each Web server without issue. [ Ansible Success](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/AnsiblePing.png)

Next I created a YAML playbook that was used to push out the Docker Web VM to each of the Web servers. This YML playbook performed a few tasks. [Pentest.yml Playbook file](https://github.com/kellyclemmensen/CXSProj1/blob/main/YAML/pentest.yml). This playbook performed the following tasks. 
- Installed the Docker.IO on each Web server
- Installed Python on each server
- Downloaded and installed Docker Web VM container
  - Published the Docker Web VM on port 80
- Set the Docker service to enabled. 

After running the Ansible playbook, the DVWA is successfully deployed. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/PentestPlaybook.png). I also confirmed the DVWA web site was running by logging into each of the Web servers and using a curl command against the local host. [Curl Command Confirmation](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/CurlConfirm.png)

### ELK Implementation

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook may be used to install only certain pieces of it, such as Filebeat.

#### Description of the Topology

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the services and system modules. The ELK server is hosted
on a single virtual machine running the Linux Operating System
- Filebeat monitors for changes in system modules. 
- Metricbeat tracks statistics for CPU usage, memory, file system, disk IO, and network IO

The configuration details of each machine may be found below.

#### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- Automation has many advantages over manual configuration
  - Time savings. 
  - Repeatability. Automation ensures the same process is followed for every configuration that is performed. 
  - Scability. Multiple configurations, hundreds/thousands, can be performed at once.

The playbook implements the following tasks:
- Docker and Python Installation/Configuration is performed. 
- Virtual machine memory is increased and configured to use all available memory
- An ELK container is downloaded and launched. The container restart policy is set to always start, and ports are published
- The Docker service is set to start on virtual machine boot

Elk Playbook Documentation - [ELK Installation Playbook](https://github.com/kellyclemmensen/CXSProj1/blob/main/YAML/install-elk.yml)

#### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the install-elk.yml file to the /etc/ansible directory inside the ansible docker container.
- Update the hosts file to include:
  - A section labeled ELK to identity the ELK servers. This will be used to distinguish between the DVWA web servers and the new ELK installation. 
  - Add the ELK server IP address as well as the Python Interpreter Path. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/ElkHost.png)
  - The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance. - [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/DockerPS.png)
- Run the playbook. After the playbook has completed successfully, open a web browser and navigate to the exteral IP address of the ELK server. In this instance, http://52.191.115.231:5601 to verify the Kibana dashboard has loaded. [Screen shot](https://github.com/kellyclemmensen/CXSProj1/blob/main/Images/KibanaWorking.png)

#### Beats
These Beats allow us to collect the following information from each machine:
- Filebeat harvests and reads logfiles in configured locations and ships new log information to the ELK server
- Metricbeat retrieves metric by periodically interrogating the host system. Metricbeat collects statistic infomration about system services. e.g. CPU and memory usage. 

This ELK server is configured to monitor the following machines:
| Machine Name  | IP Address|
|---|---|
|  Web-01 | 10.2.0.5  |
|  Web-02 | 10.2.0.6  |
|  Web-03 | 10.2.0.7  |

I installed the following Beats on these machines:
| Machine Name  | Beats Installed|
|---|---|
|  Web-01 | Filebeats, Metricbeats  |
|  Web-02 | Filebeats, Metricbeats  |
|  Web-03 | Filebeats, Metricbeats |