# AuroraLabs-Home-Assignment
Home assignment for a DevOps position on AuroraLabs

## Requirements
We would like you to provide us a running Jenkins server, that will initiate a python job<br>
on any merge request.
• You can use any git service you want, and any open-source tools that may help you.<br>
• All the system should be run as a container, using a single command from cli.<br>
• The assignment output will be a link to a (public) repository with the files describes<br><br>
below:<br>
1. README (instruction on how to run the container)<br>
2. Jenkinsfile<br>
3. main.py (python script that prints "Devops is great")<br>
4. Dockerfile (can be multiple Dockerfiles)<br>
5. docker-compose<br>

## The implementation

### Upload and install the Jenkins
1. Run ‘docker-compose -f jenkins/docker-compose.yaml build’ in order to build the image<br>
2. Run ‘docker-compose -f jenkins/docker-compose.yaml up -d’ in order to start and run the jenkins (will run on port 8080)<br>
3. On the browser, run 'http://<server_ip>:8080' and wait for Jenkins to start.<br>
4. Run ‘docker logs jenkins’ to get the installtion password and copy the password and paste on the Jenkins UI under 'Administrator password': <br>
![image](https://user-images.githubusercontent.com/64369709/229138273-e4ee3620-25d9-40cd-a4db-94ba48c8ce60.png)

5. Install the suggeted plugins:<br>
![image](https://user-images.githubusercontent.com/64369709/229138493-b919b8cb-975e-48f8-ac29-7e834c6e9489.png)

6. Create an Admin username and password for Jenkins <br>
7. On Jenkins UI, press on '+ New Item' and create a new Pipeline job called 'deployment-py-app'<br>
8. Select the 'Pipeline Definition' as 'Pipeline script from SCM', select 'SCM' as 'Git', enter the Github repository URL, cheange the branch to '*/main' and save the Pipeline job.<br>
![image](https://user-images.githubusercontent.com/64369709/229138638-bdae7ff0-3a96-4774-95c4-03b9c6968fa5.png)


### Set a Webhook on Github repository
In order to create a webhook that will start the Jenkins pipeline every time a code is merged to the main branch, we need to do the following:<br>
- On the GitHub repository, go to 'setting'--> 'Webhooks' and create a new webhook with 'Payload URL' as 'http://<jenkins_server_ip>:8080/webhook', 'content Type' as 'application/json' and press 'Active' (it's also better to create a secret to add to the webhook, go to http://<jenkins_server_ip>:8080/user/admin/configure, create a new token and set on the Webhook in Github).
<br><br>

### Set a reposetory on DockerHub
In order to push our python-app docker image to DockerHub we need to do the following:<br>
1. Create a new repository on DockerHub called 'py-aurora-app' and make it private.
![image](https://user-images.githubusercontent.com/64369709/229139581-259d1bd5-8be1-410f-b260-e8957aee91db.png)
<br>
2. On DockerHub, go to 'https://hub.docker.com/settings/security', create a 'New Access Token' and copy it's values<br>
3. Go back to Jenkins UI, go to 'http://<jenkins_server_ip>:8080/manage/credentials/store/system/domain/_/' and add new Credentials with the detils from the last step in DockerHub (I set the ID as 'dockerhub')
![image](https://user-images.githubusercontent.com/64369709/229139706-03696d63-d20b-4eeb-8461-46c826a03050.png)
<br>

### Test the Deployment pipeline
Check that on every merge to mina from PR, the pipeline is start running and deploying the 'deployment-py-app'<br>
