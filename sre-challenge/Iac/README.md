# AWS EKS Infrastructure as Code

## Overview

Terraform-based Infrastructure as Code (IaC) for deploying a web application on AWS EKS (Elastic Kubernetes Service).

## Architecture Components

### VPC Network

- Dedicated VPC for isolated network environment
- Configured with appropriate CIDR blocks for resource allocation
- NAT Gateway for public internet access
- Route tables for network traffic management

### Subnet Strategy

- **General Purpose Subnet**: Hosts supporting infrastructure and services
- **EKS Cluster Subnet**: Dedicated subnet for Kubernetes worker nodes with optimized networking

### Load Balancing

- Application Load Balancer (ALB) for external traffic distribution
- Nginx Ingress Controller for Kubernetes ingress management
- Automated SSL/TLS termination support
- Health check configuration for service reliability

### Kubernetes Workloads

Managed using the HashiCorp Kubernetes provider with:

- Deployment specifications for application pods
- Service definitions for internal networking
- ConfigMaps and Secrets for configuration management
- Persistent Volume Claims for storage requirements

## Auto Scaling Configuration

### Horizontal Pod Autoscaler (HPA)

#### Scaling Parameters

- **Minimum Replicas**: 1 (ensures continuous availability)
- **Maximum Replicas**: 3 (controls resource costs)
- **Target CPU Utilization**: 30% (balanced performance vs. resource usage)

#### Scaling Triggers

- **Primary Metric**: CPU utilization across all pods
- **Scale-Out**: Triggered when average CPU usage exceeds 30%
- **Scale-In**: Activated when average CPU usage falls below 30%

#### Prerequisites

For HPA to function correctly, ensure:

1. **Resource Definitions**: Application deployments must include CPU resource requests in pod specifications
2. **Metrics Server**: Kubernetes metrics server must be installed and running in the cluster
3. **Resource Limits**: Appropriate CPU limits set for container resources

### Benefits

- Automatic performance optimization during traffic fluctuations
- Cost efficiency through dynamic resource allocation
- Maintained application responsiveness under varying loads

## Deployment Notes

- All infrastructure components are provisioned using Terraform modules
- Kubernetes manifests are applied through Terraform's Kubernetes provider
- Configuration supports both development and production environments
- Security best practices implemented for network policies and IAM roles
