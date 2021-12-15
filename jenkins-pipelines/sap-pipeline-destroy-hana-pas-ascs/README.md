# SAP Pipeline to destroy Hana, PAS and ASCS

This is a set of scripts to run as a Jenkins pipeline

For a full understanding of how it works, please refer to the main project: <a href="https://gitlab.aws.dev/sap-devops/ci-cd-tooling/jenkins/jenkins-as-code" target="_blank">Jenkins as code</a>

## How this repo works

1. It all starts with Jenkinsfile
2. Jenkinsfile calls all the needed scripts according to each of its pipeline stages