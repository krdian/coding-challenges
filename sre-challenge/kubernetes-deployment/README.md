# Kubernetes Deployment for Web Application

## Overview

This project deploys a containerized web application on a bare-metal Kubernetes cluster using the following components:

- **Docker containers** built from the `docker-container` directory
- **NGINX** as the ingress controller
- **Horizontal Pod Autoscaler (HPA)** for automatic scaling
- **Private container registry** for hosting application images

## Manifest Files

### Core Application

1. **Application Deployment** (`app-deployment.yaml`)
   - Deploys the application pods
   - References container images from the private registry
   - Configures environment variables and resource limits

2. **Application Service** (`app-service.yaml`)
   - Exposes the deployment internally via ClusterIP
   - Load balances traffic to application pods
   - Defines port mapping and service discovery

3. **Horizontal Pod Autoscaler** (`app-hpa.yaml`)
   - Automatically scales pods based on CPU utilization
   - Configures minimum/maximum replica counts
   - Links to the application deployment

### Ingress Configuration

4. **NGINX Ingress Class** (`nginx-ingressclass.yaml`)
   - Defines the NGINX ingress controller class
   - Serves as the default ingress controller

5. **Application Ingress** (`app-ingress.yaml`)
   - Configures external HTTP/HTTPS routing rules
   - Maps domains/paths to the application service
   - Manages TLS certificates and SSL termination

### Supporting Infrastructure

6. **Private Registry Deployment** (`registry-deployment.yaml`)
   - Deploys a private Docker registry instance
   - Stores and serves container images locally

7. **Registry Service** (`registry-service.yaml`)
   - Exposes the private registry internally
   - Enables cluster-wide access to container images

## Architecture Flow

External Traffic → NGINX Ingress → Application Service → Application Pods


## Prerequisites

- Bare-metal Kubernetes cluster (v1.24+)
- NGINX Ingress Controller installed
- Network connectivity between nodes
- Persistent storage (if required by registry)

## Deployment Commands

Apply manifests in recommended order:
```bash
kubectl apply -f nginx-ingressclass.yaml
kubectl apply -f registry-deployment.yaml,registry-service.yaml
kubectl apply -f app-deployment.yaml,app-service.yaml
kubectl apply -f app-hpa.yaml
kubectl apply -f app-ingress.yaml
```
