# Vertica on Kubernetes Deployment

# Repository Structure
```/terraform                 # Terraform code for infrastructure (EKS, networking, Helm chart installation for Vertica DB Operator etc.)```

```/kubernetes           # yaml files for vertica DB Custom Resource```

```README.md                  # Technical decisions & production readiness improvements, and step-by-step usage guide```


# Cloud Provider: AWS
    • AWS EKS. 
    • AWS EBS
    • Avoiding costs by limiting the cluster size and instance type to as small as possible. 
    
# Terraform Infrastructure Deployment
  # Components
    • vps.tf: VPC module from terraform for the installation of secured private network for vertica
    • eks.tf: EKS module from terraform for installing kubernetes cluster.
    • helm.tf: Installation of helm charts for cert-manager and Vertica DB Operator.
    • output.tf: Printing the necessary details after terraform run is finished.
    • main.tf and provider.tf: Basic terraform and aws provider needed to initialize the project.
# Security Best Practices
    • IAM Roles for Service Accounts (IRSA) to grant minimal permissions to Kubernetes workloads
    • Enabling TLS for all inter-node communication.
    • Making sure that database nodes are running in private subnet.

# Deployment Steps
1. Clone Repository
   
   ```git clone git@github.com:ammartaj53/my-vertica-deployment.git```
   
   ```cd my-vertica-deployment```

2. Deploy Infrastructure and Helm Charts
    
   ```cd terraform```

   ```terraform init```

   ```terraform apply```


3. Deploy Vertica DB Custom resource
   
   ```cd kubernetes```
   ```kubectl apply -f .```

4. Verify Deployment
     
   ```kubectl get pods -n vertica```


5. Enable TLS by following the document:
   https://docs.vertica.com/25.1.x/en/security-and-authentication/internode-tls/

   Login to the pod and follow the instruction from above mentioned document.

   $ kubectl exec -it -n vertica verticadb-sample-sc-0 -- /bin/bash

# Next Steps for Production Readiness
    • High Availability: Use multi-AZ deployments for better resilience. 
    • Scaling: Implement Horizontal Pod Autoscaler (HPA) for workload scaling and choosing appropriate size for EBS volumes.
    • Monitoring & Logging: Integrate with Prometheus & Grafana for observability. 
    • Using RBAC: To tighten the access rights on the cluster.
    • Enhancing TLS Security: Following the suggested Security practices from Vertica itself to make sure that our Vertica installation is properly secure and encrypted using https://docs.vertica.com/25.1.x/en/security-and-authentication/
