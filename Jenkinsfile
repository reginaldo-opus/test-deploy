pipeline {
  agent {
    kubernetes {
      cloud 'delend-HML-k8s'              // nome configurado no Jenkins
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-agent
spec:
  serviceAccountName: jenkins-agent
  containers:
    - name: jnlp
      image: jenkins/inbound-agent:latest
      args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
    - name: kubectl
      image: bitnami/kubectl:1.30
      command: ['cat']
      tty: true
    - name: helm
      image: alpine/helm:3.14.0
      command: ['cat']
      tty: true
"""
    }
  }

  environment {
    APP_NAME   = "test-deploy"
    NAMESPACE  = "dev"
    RELEASE    = "test-deploy"
    IMAGE      = "ghcr.io/reginaldo-opus/test-deploy"
    TAG        = "build-${env.BUILD_NUMBER}"
    CHART_PATH = "charts/test-deploy"   // ajuste conforme seu repo
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Image (Kaniko opcional)') {
      when { expression { fileExists('Dockerfile') } }
      steps {
        container('kubectl') {
          echo "Build de imagem seria feito aqui se houver Dockerfile"
        }
      }
    }

    //stage('Deploy com Helm - DEV') {
    //  steps {
    //    container('helm') {
    //      sh '''
    //        helm upgrade --install ${RELEASE} ${CHART_PATH} \
    //          -n ${NAMESPACE} \
    //          --set image.repository=${IMAGE} \
    //          --set image.tag=${TAG} \
    //          --wait --timeout 5m
    //      '''
    //    }
    //  }
    //}

    stage('Verificar -Teste Basico') {
      steps {
        container('kubectl') {
          sh '''
            kubectl get ns
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finalizado no pod-agente Kubernetes."
    }
  }
}
