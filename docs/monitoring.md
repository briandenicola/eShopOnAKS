Monitoring
=============
TBD
<p align="right">(<a href="#monitoring">back to top</a>)</p>

# Open Telemetry Pipeline
```yaml
  pipelines:
    traces:
      receivers: [zipkin]
      processors: [batch]
      exporters: [debug,azuremonitor]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug,azuremonitor]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug,azuremonitor]
```

# Metrics - Grafana Example Dashboards and Prometheus Queries 
## Threads
<img src="../.assets/grafana-threads.png" width="1024px" />

## Memory Usage
<img src="../.assets/grafana-memory.png" width="1024px" />

## Network
<img src="../.assets/grafana-network.png" width="1024px" />
<p align="right">(<a href="#monitoring">back to top</a>)</p>

# Application Logs - Application Insights
## Logging
<img src="../.assets/appinsights-logging.png" width="1024px" />

## Application Map
<img src="../.assets/appinsights-app-map.png" width="1024px" />
<p align="right">(<a href="#monitoring">back to top</a>)</p>

# Traces - Application Insights
<img src="../.assets/appinsights-dist-trace.png" width="1024px" />
<p align="right">(<a href="#monitoring">back to top</a>)</p>

# Navigation
[Previous Section ⏪](./deployment.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./testing.md)
<p align="right">(<a href="#monitoring">back to top</a>)</p>