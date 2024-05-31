Scaling
=============
* The eShop has been deployed with KEDA for autoscaling and Pod Disruption Budgets to ensure high availability.

# Pod Disruption Budget
* Pod Disruption Budget (PDB) are used to ensure that a certain number of pods are available during maintenance or other disruptions.
* The application has a Pod Disruption Budget (PDB) defined to ensure that at least one pod is available at all times.
* The PDB is defined in the Helm Chart and is applied to the application deployment.
```yaml
  apiVersion: policy/v1
  kind: PodDisruptionBudget
  metadata:
    name: {{ .Chart.Name }}-pdb
  spec:
    minAvailable: 1
    selector:
      matchLabels:
        app: {{ .Chart.Name }}
```
<p align="right">(<a href="#scaling">back to top</a>)</p>

# KEDA Scalers
* KEDA is used to provide event-driven autoscaling for Kubernetes workloads that goes beyond the standard Kubernetes HPA options.
* The eShop application has been deployed with a KEDA HTTP Scaler to scale the webapp service on the number of incoming HTTP requests.
```yaml
  kind: HTTPScaledObject
  apiVersion: http.keda.sh/v1alpha1
  metadata:
    name: webapp
    namespace: {{ .Values.NAMESPACE }}
  spec:
    hosts:
    - {{ .Values.ISTIO.WEBAPP.EXTERNAL_URL }}
    scaleTargetRef:
      service: webapp
      name: webapp       
      port: 80
    replicas:
      min: 1
      max: 5
    scaledownPeriod: 300
    scalingMetric:
      requestRate:
        granularity: 1s
        targetValue: 100
        window: 1m      
```
<p align="right">(<a href="#scaling">back to top</a>)</p>

# Optional Next Steps
* :question: Given the current PDB configuration, what would happen using a Node Image update given the default number of replicas per pod?
* :question: How would you update the application configuration?
* :question: What other KEDA Scalers could be added to the application?
* :question: How can you ensure pods are properly spread across AKS nodes or Azure Availablity Zones? 
<!-- * :+1: _Hint: Pod Topology Spread Constraints_ -->
* :question: How resilent is this application design to an Azure Regional Outage? How to improve the design for multiple regions?
   * **Hint:** [Azure Mission Critical](https://github.com/Azure/Mission-Critical-Connected)
  
<p align="right">(<a href="#scaling">back to top</a>)</p>

# Navigation
[Previous Section ⏪](./testing.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./cost-management.md)
<p align="right">(<a href="#scaling">back to top</a>)</p>