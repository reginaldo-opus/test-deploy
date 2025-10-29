pipeline {
  agent {
    kubernetes {
      // Nome do Cloud conforme configurado no Jenkins
      cloud 'Cluster'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: test-agent
spec:
  serviceAccountName: jenkins-agent
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args: ['\\$(JENKINS_SECRET)', '\\$(JENKINS_NAME)']
  - name: kubectl
    image: bitnami/kubectl:1.30
    command: ['cat']
    tty: true
"""
    }
  }

  stages {
    stage('Verificar conexão com cluster') {
      steps {
        container('kubectl') {
          sh 'kubectl get ns'
        }
      }
    }

    stage('Ver informações do Pod do agente') {
      steps {
        container('kubectl') {
          sh 'kubectl get pods -n ci -o wide'
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline finalizado.'
    }
  }
}
