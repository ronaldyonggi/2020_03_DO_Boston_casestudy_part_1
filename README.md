# Case Study: CI/CD Pipeline, Part 1

A documentation for CI/CD pipeline utilizing DevOps tools and AWS services.

<p align="center">
<img
    alt="Pipeline"
    src="https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/mario.jpg"
    width="300"
/>
<h2>
"No, not *this* pipeline. I'm talking about DevOps pipeline..."
</h2>
</p>

## Install Ansible in Local Machine

Local machine runs on Lubuntu OS. Followed the steps [here] for Ubuntu-based installation.
## Create an EC2 instance using Amazon Linux 2 AMI as base for Jenkins Server

For ease of usage and testing, a security group that allows all inbound traffic is used. This is against security best practices, NOT RECOMMENDED for most real use cases. A free-tier, t2.micro instance running on Amazon Linux 2 AMI OS is used. 

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/ami.jpg)

## Install Git within the EC2 instance (Automated via Ansible Playbook)

By default, a fresh created EC2 instance doesn't come with Git. In this project, Git installation is automated using Ansible. See `JenkinsServer.yml`
```
- name: ensure git is at the latest version
  yum:
    name: git
    state: latest
```

## Install Docker within the EC2 instance (Automated with Ansible)

Installation is automated using Ansible. See `JenkinsServer.yml`
```
- name: Docker installation and configuration
    block:
    - name: install Docker from amazon-linux-extras
        command: amazon-linux-extras install -y docker

    - name: start Docker service and enable on machine boot
        service:
        name: docker
        state: started
        enabled: yes

    - name: create 'docker' usergroup
        group:
        name: docker
        state: present

    - name: add ec2-user to docker group so that docker commands can be executed without sudo
        user: 
        name: ec2-user
        group: docker
        append: yes
```

## Install Jenkins within the EC2 instance (Automated with Ansible)

Jenkins installation followed the documentation written in Jenkins official page. Follow the [Red Hat / CentOS, LTS Installation](https://www.jenkins.io/doc/book/installing/linux/#long-term-support-release-3). This process is automated using Ansible as well. See `JenkinsServer.yml`

```
- name: install Java JDK (required for Jenkins installation)
    yum: 
    name: java-1.8.0-openjdk-devel

- name: Jenkins installation and configuration
    block:
    - name: download Jenkins repository using wget
        get_url:
        url: https://pkg.jenkins.io/redhat-stable/jenkins.repo
        dest: /etc/yum.repos.d/jenkins.repo

    - name: import Jenkins key
        rpm_key:
        state: present
        key: https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    - name: install Jenkins
        yum:
        name: jenkins
        state: present

    - name: issue daemon_reload to pick up config changes
        systemd: daemon_reload=yes

    - name: start Jenkins and enable during machine boot
        service: 
        name: jenkins
        state: started
        enabled: yes

    - name: delay 30 secs before executing next task (wait for Jenkins to start first)
        wait_for: timeout=30

    - name: get the initial Jenkins admin password 
        command: cat /var/lib/jenkins/secrets/initialAdminPassword 
        changed_when: false
        register: passw

    - name: print the initial Jenkins admin password
        debug:
        var: passw.stdout

    - name: add jenkins-user to docker group to allow jenkins to connect to docker.sock (required for pipeline build docker image)
        user: 
        name: jenkins
        group: docker
        append: yes
```

#### Install Jenkins Plugins

The following plugins are installed in this project:
1. Git plugin
2. Pipeline
3. Docker
4. GitHub

#### Accessing Jenkins

Jenkins GUI can be accessed via the EC2 instance's public IP address. Add `:8080` at the end, since by default Jenkins runs on port 8080.

#### Restart Jenkins

Use `sudo service jenkins restart` to restart Jenkins. This is useful for restarting Jenkins after installing plugins.

## Jenkins Job Configuration: Pipeline

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/pipeline.jpg)
![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/gitpoll.jpg)
![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/fromSCM.jpg)

## Build Dockerized App Image and Push to ECR

1. Create a new repository in the ECR
2. Select your newly created repository and choose `View push command`
3. Follow the directions to build and push your image to the ECR repository.
