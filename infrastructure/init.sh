 #!/bin/bash
       
       set -x

       #######DOCKER############
       sudo yum update
       sudo yum install -y docker
       systemctl enable docker
       systemctl start docker
       sudo usermod -a -G docker ec2-user

       #####Minikube######
       curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
       minikube start

       ####KUBECTL######
       curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
       install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
       chmod +x kubectl
       sudo mv ./kubectl /usr/local/bin

       ######HELM#######
       # Download the Helm script
       curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
       # Move the Helm binary to /usr/local/bin
       sudo mv $(which helm) /usr/local/bin/helm
       # Set execute permissions on the binary
       sudo chmod 755 /usr/local/bin/helm   

       #####JENKINS#######
       yum update -y
       wget -O /etc/yum.repos.d/jenkins.repo \
           https://pkg.jenkins.io/redhat-stable/jenkins.repo
       rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
       yum upgrade -y
       amazon-linux-extras install java-openjdk11 -y
       yum install jenkins git -y
       systemctl enable jenkins
       systemctl start jenkins
       usermod -aG docker jenkins
       
      ###### Give Jenkins user rights to install helm chart in minikube#####
       
      #######Create a new role called "jenkins" that has the necessary permissions to install Helm charts######

      echo "
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: jenkins
rules:
- apiGroups: ["*"]
  resources: ["deployments", "namespaces", "services", "pods", "replicasets", "ingresses", "configmaps", "secrets", "extensions", "apps", "replicasets/scale", "deployments/scale", "replicationcontrollers/scale"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]" >>role.yaml

      #########Create a new role binding that binds the "jenkins" role to the Jenkins user######

      echo "
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jenkins
subjects:
- kind: User
  name: jenkins
  apiGroup: ""
roleRef:
  kind: Role
  name: jenkins
  apiGroup: """ >>rolebinding.yaml


  #########3.	Apply the role and role binding######

  kubectl apply -f ./role.yaml
  kubectl apply -f ./rolebinding.yaml





        