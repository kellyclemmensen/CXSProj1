
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below. 

Diagram location: [Azure Diagram](https://github.com/kellyclemmensen/CyberSecurityBootcamp-Project1/blob/main/Project1-AzureBuildOut.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook may be used to install only certain pieces of it, such as Filebeat.

Elk Playbook Documentation
  - [ELK Installation Playbook](https://github.com/kellyclemmensen/CyberSecurityBootcamp-Project1/blob/main/install-elk.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

The DVWA Web Application is hosted on 3 Web Servers running the Linux Operating System. All web servers are in an Azure Availability Set. 
This ensures Web Server virtual machines are not hosted in the same location and are patched at different times.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- Load balancers serve multiple purposes. 
  - At their core, LBs distribute traffic between configured backend workloads. 
  - They verify health state of backend workloads and make sure they are online before sending traffic
- From the aspect of security, LBs prevent access directly to backend resource, adding a layer of control over access to the backend resource. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the services and system modules. The ELK server is hosted
on a single virtual machine running the Linux Operating System
- Filebeat monitors for changes in system modules. 
- Metricbeat tracks statistics for CPU usage, memory, file system, disk IO, and network IO

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump-Provisioner | Gateway/Ansible Controller  | 10.2.0.4   | Linux            |
| Web-01     |  Web Server        | 10.2.0.5          | Linux        |
| Web-02     |  Web Server        | 10.2.0.6          | Linux        |    
| Web-03     |  Web Server        | 10.2.0.7          | Linux        |
| ELK-01     | ELK Stack Server   | 10.10.0.4         | Linux      |

### Access Policies

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
- _TODO: In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc._

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the _____ file to _____.
- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
