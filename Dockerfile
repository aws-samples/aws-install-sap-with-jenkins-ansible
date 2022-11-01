FROM centos:centos8

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum update -y
RUN yum install -y wget

RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum install epel-release-latest-8.noarch.rpm -y
RUN yum update -y

#sudo yum install curl vim git unzip python3 openssl ansible -y
RUN yum install curl vim git unzip python3 openssl python3-pip -y
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install ansible
RUN ln -s /usr/local/bin/ansible-playbook /usr/bin/ansible-playbook

RUN rm -rf /home/centos/jenkins
RUN git clone https://github.com/aws-samples/aws-install-sap-with-jenkins-ansible.git /home/centos/jenkins
RUN ansible-playbook /home/centos/jenkins/jenkins-as-code/site.yml

RUN sleep 30s

RUN bash /home/centos/jenkins/jenkins-as-code/general-test.sh