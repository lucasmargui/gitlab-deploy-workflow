# 🧩 GitLab Deploy Workflow

This repository provides a step-by-step guide to creating and managing a GitLab CI/CD pipeline for deploying applications. It covers everything from setting up the GitLab project, configuring runners, building Docker images, and deploying to production environments. Ideal for developers and DevOps engineers looking to automate their deployment workflow efficiently.

<details>
  <summary><b>📘 Table of Contents</b></summary>

- [🔐 Configuring AWS CLI Access Using IAM](#configuring-aws-cli-access-using-iam)  
  - [Step 1 – Install AWS CLI](#step-1--install-aws-cli)  
  - [Step 2 – Create a User Group (IAM Group)](#step-2--create-a-user-group-iam-group)  
  - [Step 3 – Create an IAM User](#step-3--create-an-iam-user)  
  - [Step 4 – Generate Access Keys](#step-4--generate-access-keys)  
  - [Step 5 – Configure the AWS CLI](#step-5--configure-the-aws-cli)  

- [🔑 Creating SSH Key Pair](#creating-ssh-key-pair)  
  - [Step 1 – Access the EC2 Service](#step-1--access-the-ec2-service)  
  - [Step 2 – Create a New Key Pair](#step-2--create-a-new-key-pair)  

- [☁️ Create GitLab directory/repository](#-create-gitlab-directoryrepository)
  - [Step 1 – Create GitLab Account](#step-1--create-gitlab-account)
  - [Step 2 – Create a New Project](#step-2--create-a-new-project)
  - [Step 3 – Initialize Local Repository](#step-3--initialize-local-repository)
  - [Step 4 – Link Repository and Push Code](#step-4--link-repository-and-push-code)
  - [Step 5 – Provision EC2 Instance with Terraform](#step-5--provision-ec2-instance-with-terraform)
  - [Step 6 – Install GitLab Runner](#step-6--install-gitlab-runner)
  - [Step 7 – Register GitLab Runner](#step-7--register-gitlab-runner)
  - [Step 8 – Configure GitLab Runner User](#step-8--configure-gitlab-runner-user)
  - [Step 9 – Docker Hub Authentication](#step-9--docker-hub-authentication)

- [🐳 CI/CD Pipeline – Containerized Application](#-ci-cd-pipeline--containerized-application)
  - [Step 1 – Configure .gitignore](#step-1--configure-gitignore)
  - [Step 2 – Create Dockerfile](#step-2--create-dockerfile)
  - [Step 3 – Configure GitLab Pipeline](#step-3--configure-gitlab-pipeline)
  - [Step 4 – Build Docker Image](#step-4--build-docker-image)
  - [Step 5 – Deploy Container](#step-5--deploy-container)
  - [Step 6 – Update Application Version](#step-6--update-application-version)

</details>

---

## 🔐 Configuring AWS CLI Access Using IAM

This section explains how to set up AWS CLI authentication using **IAM (Identity and Access Management)**, allowing secure command-line access to your AWS resources.

<details> <summary>Click to show details</summary> 

### Step 1 – Install AWS CLI

Install and configure the **AWS Command Line Interface (AWS CLI)** — a unified tool that enables you to manage AWS services directly from your terminal.

<details>
  <summary>Click to show details</summary>
  <img width="1130" height="622" alt="AWS CLI Installation" src="https://github.com/user-attachments/assets/43bb56e1-bf6b-40fe-bd60-e54fa4cec711" />
</details>

---

### Step 2 – Create a User Group (IAM Group

1. In the AWS Management Console, navigate to **IAM (Identity and Access Management)**.  
2. On the sidebar, select **Groups → Create Group**.  
3. Name the group **cli-users**.  
4. Attach the **AdministratorAccess** policy (recommended only for testing environments).  
5. Click **Create Group** to finalize.

<details>
  <summary>Click to show details</summary>
  <img width="1047" height="225" alt="IAM Groups Navigation" src="https://github.com/user-attachments/assets/92650f80-33c6-4d39-8235-16ae47407761" />
  <br>
  <img width="1062" height="252" alt="IAM Group Creation" src="https://github.com/user-attachments/assets/2fad42b5-2c87-4ba2-b765-ac3d529f1ea1" />
</details>

---

### Step 3 – Create an IAM User

1. Still inside **IAM**, go to **Users → Add User**.  
2. Set the username to **lucasmarguaws**.  
3. Select the **Programmatic access** option (for CLI access).  
4. Add the user to the previously created **cli-users** group.  
5. Click **Create User** to complete the process.

<details>
  <summary>Click to show details</summary>
  <img width="728" height="140" alt="IAM User Creation Step 1" src="https://github.com/user-attachments/assets/ae621945-2f48-447f-9837-8ec394ad1b0f" />
  <br>
  <img width="1037" height="540" alt="IAM User Group Association" src="https://github.com/user-attachments/assets/4e0ecf82-1d45-43f4-b0b5-5c740d6c08f8" />
</details>

---

### Step 4 – Generate Access Keys

1. After the user is created, click the username (**lucasmarguaws**) to view its details.  
2. Go to the **Security credentials** tab.  
3. Click **Create access key** and choose the **Command Line Interface (CLI)** usage type.  
4. Copy and securely store the **Access Key ID** and **Secret Access Key** — they will be required for AWS CLI authentication.

<details>
  <summary>Click to show details</summary>
  <img width="1072" height="201" alt="Access Key Creation" src="https://github.com/user-attachments/assets/19d9bdb2-5f9f-41e0-a718-2936f005f8e0" />
  <br>
  <img width="1036" height="185" alt="Access Key Output" src="https://github.com/user-attachments/assets/002ec936-e699-486f-8693-9a9b4d515215" />
</details>

---

### Step 5 – Configure the AWS CLI

Open your terminal or Command Prompt and run:

```bash
aws configure
```

Provide your credentials when prompted:

```bash
AWS Access Key ID [None]: <your-access-key-id>
AWS Secret Access Key [None]: <your-secret-access-key>
Default region name [None]: us-east-1
Default output format [None]: json
```

<details> <summary>Click to show details</summary> <img width="996" height="142" alt="AWS Configure Example" src="https://github.com/user-attachments/assets/407e723f-8e12-4aae-8f38-4a7d4367a333" /> </details>

✅ Once completed, your AWS CLI is fully authenticated and ready to execute AWS commands or apply Terraform scripts securely and automatically.

</details>

---

## 🔑 Creating SSH Key Pair

This section describes how to create a **Key Pair** in AWS to enable secure **SSH access** to your EC2 instance.


<details> <summary>Click to show details</summary> 

### Step 1 – Access the EC2 Service

1. Open the **AWS Management Console**.  
2. Navigate to the **EC2** service.  

---

### Step 2 – Create a New Key Pair

1. In the left navigation pane, go to **Key Pairs** under **Network & Security**.  
2. Click **Create key pair**.  
3. In the **Name** field, enter: **Terraform**.  
4. Under **File format**, select **.ppk** (for PuTTY).  
5. Click **Create key pair**.  
6. Your browser will automatically download the file **Terraform.ppk**.  

💾 Save it in a secure location, for example:  

```
C:\Users<YourUser>.ssh\Terraform.ppk
```

✅ This key pair will later be referenced in Terraform to allow **SSH access** to the EC2 instance.

</details>

---


## ☁️ Create GitLab directory/repository

GitLab is an all-in-one DevOps platform offering:  

- **Version Control:** Git-based versioning system.  
- **Continuous Integration (CI):** Automates build, test, and deployment of code on every change.  
- **Continuous Delivery (CD):** Automates deployment to testing, staging, and production environments reliably and consistently.  
- **Issue Tracking:** Manage issues and tasks for progress monitoring.  
- **Team Collaboration:** Unified platform for development, testing, and delivery, improving efficiency and reducing errors.  

Our goal is to publish code, build containers, and deploy them to a Kubernetes cluster automatically.


<details>
  <summary>Click to show details</summary>

### Step 1 – Create GitLab Account

1. Visit [GitLab](https://gitlab.com/)  
2. Sign up for a free account or log in if you already have one.

---

### Step 2 – Create a New Project

1. Click **New Project**  
2. Select **Blank Project**  
3. Set the **project name** and click **Create Project**  
4. After creation, GitLab will display instructions to initialize a local repository.

<details><summary>Click to show details</summary> <img width="814" height="678" alt="image" src="https://github.com/user-attachments/assets/28a3c6f9-cca0-44c3-8896-0a0c270d5e46" /> </details>

---

### Step 3 – Initialize Local Repository

1. Create a local directory for your project:

```bash
mkdir bootcampt-devops-project-1
cd bootcampt-devops-project-1
```
<details><summary>Click to show details</summary> <img width="948" height="309" alt="image" src="https://github.com/user-attachments/assets/3836e5e7-e6b1-45f1-a44d-78824c3685cf" /> </details>

2. Initialize Git:

```
git init --initial-branch=main --object-format=sha1
```

3. Configure local user information:

```
git config --local user.name "Your Name"
git config --local user.email "your.email@example.com"
```

---

### Step 4 – Link Repository and Push Code

1. Add the GitLab remote repository:

```
git remote add origin git@gitlab.com:lucasmargui/bootcampt-devops-project-1.git
```

2. Stage files for commit:

```
git add .
```

3. Make the initial commit:

```
git commit -m "Initial commit"
```

4. Push the code to GitLab:

```
git push --set-upstream origin main
```

---


---

### Step 5 – Provision EC2 Instance with Terraform

1. Reuse the existing bootcampt-devops-project-1 to configure a terraform and create a new EC2 instance for your GitLab Runner.

  <details><summary>Click to show details</summary> <img width="754" height="511" alt="image" src="https://github.com/user-attachments/assets/83a6fb63-c1eb-47bf-a60f-8eda49454b82" /></details>
   
3. Initialize Terraform:
   
```bash
terraform init
````


3. Apply the Terraform plan to create the EC2 instance:

```bash
terraform apply
```

4. After the instance is created, connect via SSH using PuTTY:

- Username: ubuntu
- Private Key: The one created previously (Terraform.ppk)

<details><summary>Click to show details</summary> <img width="775" height="379" alt="image" src="https://github.com/user-attachments/assets/9c42edf2-5c80-4b0d-9b3f-565c207bf74a" /></details>

---

### Step 6 – Install GitLab Runner

1. SSH into your EC2 instance.
2. Install GitLab Runner

<details><summary>Click to show details</summary> <img width="768" height="308" alt="image" src="https://github.com/user-attachments/assets/1acc95dd-99d3-4749-8c7d-088f2dcdefde" /> </details>

<details><summary>Click to show details</summary>  <img width="960" height="189" alt="image" src="https://github.com/user-attachments/assets/034e4406-3940-49d5-9200-11842f93970f" /> </details>

<details><summary>Click to show details</summary> <img width="959" height="111" alt="image" src="https://github.com/user-attachments/assets/513d0645-8315-4808-bac8-13191b6a0467" /> </details>


```
sudo apt-get update
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner
```

3. Confirm installation by pressing Enter when prompted.
Note: You can also pre-install GitLab Runner in the Terraform configuration.

---

### Step 7 – Register GitLab Runner

1. In GitLab, navigate to your project: Settings > CI/CD > Runners > New Project Runner
   
  <details><summary>Click to show details</summary> <img width="957" height="363" alt="image" src="https://github.com/user-attachments/assets/84ae904a-cf26-41d0-86ce-d25023ac0bf9" /> </details>

2. Copy the registration token from the three dots menu.

  <details><summary>Click to show details</summary> <img width="907" height="342" alt="image" src="https://github.com/user-attachments/assets/6c162ef5-1eee-4008-be48-b583e7127b18" /> </details>

3. On your EC2 instance, register the runner:

```
sudo gitlab-runner register
```

- GitLab instance URL: https://gitlab.com/
- Registration token: Copy from GitLab
- Runner tags: shell (or any tags you prefer)

<details><summary>Click to show details</summary> <img width="805" height="233" alt="image" src="https://github.com/user-attachments/assets/3e1db82b-2ad6-4c99-904c-6e5341a5f913" /> </details>

4. Your runner is now registered and ready to receive jobs

<details><summary>Click to show details</summary> <img width="949" height="423" alt="image" src="https://github.com/user-attachments/assets/28e65778-39f4-43fe-a5ce-b6bcc46228fb" /> </details>

---

### Step 8 – Configure GitLab Runner User

1. GitLab Runner creates a user called gitlab-runner. Verify in:

```
cat /etc/passwd | grep gitlab-runner
```

2. Add the runner to the Docker group to allow building and running containers:

```
sudo usermod -aG docker gitlab-runner
```

---

### Step 9 – Docker Hub Authentication

1. Switch to root user (if needed, set a root password first):

```
sudo passwd root
su
```

2. Set a password for gitlab-runner:

```
passwd gitlab-runner
```

3. Switch to the gitlab-runner user:

```
su gitlab-runner
```

4. Log in to Docker Hub (or company Docker registry):

```
docker login -u "your-username"
```

<details><summary>Click to show details</summary> <img width="945" height="302" alt="image" src="https://github.com/user-attachments/assets/6f616e78-4542-4e26-aa5f-d988dfb565b9" /> </details>

</details>

---

## 🐳 CI/CD Pipeline – Containerized Application

<details>
  <summary>Click to show details</summary>

### Step 1 – Configure .gitignore

- Create a `.gitignore` file at the root of the repository.  
- Add files and directories that should not be versioned, such as Terraform state files or logs.
  
```
.terraform*
terraform*
```

---

### Step 2 – Create Dockerfile

Inside your application directory, create a Dockerfile.

This file will be used to build the container image.

Minimal example:

```bash
FROM httpd:latest

WORKDIR /usr/local/apache2/htdocs/

COPY * /usr/local/apache2/htdocs/

EXPOSE 80
```

<details><summary>Click to show details</summary> <img width="945" height="217" alt="image" src="https://github.com/user-attachments/assets/8def7026-6029-4e43-a254-1626aae074e9" /> </details>

---

### Step 3 – Configure GitLab Pipeline

Create a .gitlab-ci.yml file at the root of the repository.

Divide the pipeline into stages (main sections) and jobs (tasks inside stages).

```
stages:
  - build
  - deploy
variables:
  GLOBAL_VAR: "2.0"
```

<details><summary>Click to show details</summary> <img width="241" height="126" alt="image" src="https://github.com/user-attachments/assets/ae4d1dea-efd2-473d-8416-ca22c9eb2e26" /> </details>

---

### Step 4 – Build Docker Image

- Job to build and push the Docker image:

```
criar_imagens:
  stage: build
  tags:
    - aws
  script:
  - docker build -t lucasmargui/app-bootcamp-devops:$GLOBAL_VAR app/.
  - docker push lucasmargui/app-bootcamp-devops:$GLOBAL_VAR
```

1. Stage: build
- This job is part of the build stage in the CI/CD pipeline.

2. Tags: aws
- Specifies that this job should run on runners tagged with aws (created in e2c).

3. Script:

- docker build -t lucasmargui/app-bootcamp-devops:$GLOBAL_VAR app/
Builds a Docker image using the Dockerfile located in the app/ directory.
The image name will be lucasmargui/app-bootcamp-devops and the tag will be set using the environment variable $GLOBAL_VAR.

- docker push lucasmargui/app-bootcamp-devops:$GLOBAL_VAR
Pushes the built Docker image to the remote Docker repository.


<details><summary>Click to show details</summary> <img width="582" height="155" alt="image" src="https://github.com/user-attachments/assets/20de9ab6-8057-464a-b3a0-4c957d7a53a2" /> </details>

- Add and commit the new files:

```
git add .
git commit -m "Create CI/CD Pipeline"
git push --set-upstream origin main
```

---

### Step 5 – Deploy Container

- Job to run the container on the production server:
  
```
executar_imagens:
  stage: deploy
  needs:
    - criar_imagens
  tags:
    - aws
  before_script:
  - docker rm $(docker ps -a -q) --force
  script:
  - docker run -dti --name web-server -p 80:80 lucasmargui/app-bootcamp-devops:$GLOBAL_VAR
  after_script:
  - docker system prune --force
```

1. Stage: deploy
- This job runs in the deploy stage of the CI/CD pipeline.

2. Dependencies: needs: criar_imagens
- Ensures this job only runs after the criar_imagens job has successfully completed.

3. Tags: aws
- Specifies that this job should run on runners tagged with aws.

4. Before Script:
```
docker rm $(docker ps -a -q) --force
```
- Removes all existing Docker containers to ensure a clean environment before starting the new container.

5. Script:
```
docker run -dti --name web-server -p 80:80 lucasmargui/app-bootcamp-devops:$GLOBAL_VAR
```
- Runs the Docker image in a detached and interactive terminal mode.
- Names the container web-server
- Maps port 80 on the host to port 80 in the container
- Uses the image lucasmargui/app-bootcamp-devops with the tag $GLOBAL_VAR.

6. After Script:
```
docker system prune --force
```
- Cleans up unused Docker objects to free disk space and keep the environment tidy.

<details><summary>Click to show details</summary> <img width="712" height="284" alt="image" src="https://github.com/user-attachments/assets/74a2dca4-b9f1-4bed-a21a-3f0988ef5e4a" /> </details>


- Add, commit, and push:

```
git add .
git commit -m "Deploy container"
git push
```

- Verify in GitLab that the container is running successfully.

---

### Step 6 – Update Application Version

To update the application (e.g., version 2.0 → 3.0):

```
variables:
  GLOBAL_VAR: "3.0"
```


<details><summary>Click to show details</summary> <img width="524" height="443" alt="image" src="https://github.com/user-attachments/assets/cc405bed-a7a6-4095-b8d3-0f7281f91d96" /> </details>

</details>

---
