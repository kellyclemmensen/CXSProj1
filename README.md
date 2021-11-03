## Document Topics
- Automated ELK Stack Deployment
  - ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- Cybersecurity Bootcamp Scripts
- Kibana Investigation Summary
- Access Policies
- How to Use the Ansible Build

## Automated ELK Stack Deployment

### Overview
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.
ELK Stack implementation was build for the purposes of doing investigation into log and system module activity. This implementation leverages Infrastructure as a Service (IAAS) to build the environment in which DVWA web sites and the ELK stack implement is built on. 

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
|  Load Balancer   |    Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- Load balancers serve multiple purposes. 
  - At their core, LBs distribute traffic between configured backend workloads. 
  - They verify health state of backend workloads and make sure they are online before sending traffic
- From the aspect of security, LBs prevent access directly to backend resource, adding a layer of control over access to the backend resource. | 
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



#### Network Security Groups | Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump-Provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following external IP addresses:
- 73.45.45.20

Machines within the network can only be accessed by the Ansible Controller.
- Ansible Controller running on the Jump-Provisioner machine @ 10.2.0.4

A summary of the access policies in place can be found in the table below.

| Name  | Publicly Accessible  | Allowed IP Addresses  | Port  |
|---|---|---|---|
|  Jump-Provisioner | Yes  | 73.45.45.20  | 22  |
| Elk-01  | Yes  | 73.45.45.20  | 5601  | 
| Web Servers | Yes | 73.45.45.20 | 80 |


Diagram location: [Azure Diagram](https://github.com/kellyclemmensen/CXSProj1/blob/main/Diagrams/Project1-AzureBuildOut.png)


These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook may be used to install only certain pieces of it, such as Filebeat.

Elk Playbook Documentation
  - [ELK Installation Playbook](https://github.com/kellyclemmensen/CyberSecurityBootcamp-Project1/blob/main/install-elk.yml)

This document contains the following details:


### Description of the Topology





Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the services and system modules. The ELK server is hosted
on a single virtual machine running the Linux Operating System
- Filebeat monitors for changes in system modules. 
- Metricbeat tracks statistics for CPU usage, memory, file system, disk IO, and network IO

The configuration details of each machine may be found below.



 

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- Automation has many advantages over manual configuration
  - Time savings. 
  - Repeatability. Automation ensures the same process is followed for every configuration that is performed. 
  - Scability. Multiple configurations, hundreds/thousands, can be performed at once.

The playbook implements the following tasks:
- Docker and Python Installation/Configuration is performed. 
- Virtual machine memory is increased and confiured to use all available memory
- An ELK container is downloaded and launched. The container restart policy is set to always start, and ports are published
- The Docker service is set to start on virtual machine boot

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.
- [Docker PS Output image after Docker installation](https://github.com/kellyclemmensen/CyberSecurityBootcamp-Project1/blob/main/DockerPSOutput.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
| Machine Name  | IP Address|
|---|---|
|  Web-01 | 10.2.0.5  |
|  Web-02 | 10.2.0.6  |
|  Web-03 | 10.2.0.7  |

We have installed the following Beats on these machines:
| Machine Name  | Beats Installed|
|---|---|
|  Web-01 | Filebeats, Metricbeats  |
|  Web-02 | Filebeats, Metricbeats  |
|  Web-03 | Filebeats, Metricbeats |

These Beats allow us to collect the following information from each machine:
- Filebeat harvests and reads logfiles in configured locations and ships new log information to the ELK server
- Metricbeat retrieves metric by periodically interrogating the host system. Metricbeat collects statistic infomration about system services. e.g. CPU and memory usage. 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the install-elk.yml file to the /etc/ansible directory inside the ansible docker container.
- Update the hosts file to include:
  - A section labeled ELK to identity the ELK servers. This will be used to distinguish between the DVWA web servers and the new ELK installation. 
  - The ELK server IP address as well as the Python Interpreter Path
- Run the playbook. After the playbook has completed successfully, open a web browser and navigate to http://52.191.115.231:5601 to verify the Kibana dashboard has loaded. 

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
