Scaling
=============
TBD
<p align="right">(<a href="#scaling">back to top</a>)</p>

# KEDA HTTP Scaler
<!-- kind: HTTPScaledObject
apiVersion: http.keda.sh/v1alpha1
metadata:
    name: webapp
    namespace: {{ .Values.NAMESPACE }}
spec:
    hosts:
    - {{ .Values.ISTIO.WEBAPP.EXTERNAL_URL }}
    scaleTargetRef:
        name: webapp
        kind: Deployment
        apiVersion: apps/v1
        service: webapp
        port: {{ .Values.ISTIO.WEBAPP.PORT }}
    replicas:
        min: 1
        max: 5 -->
        
# Pod Disruption Budget
<!-- apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ .Chart.Name }}-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: {{ .Chart.Name }} -->

# Navigation
[Previous Section ⏪](./monitoring.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./cost-management.md)
<p align="right">(<a href="#scaling">back to top</a>)</p>