# Terraform Module: Kubernetes Platform with Managed PostgreSQL

This Terraform module sets up a complete Kubernetes-based application platform on **AWS**, including:

- ✅ **Amazon EKS** (Kubernetes)
- ✅ **Amazon RDS for PostgreSQL**
- ✅ **NGINX ingress controllers** (public & private)
- ✅ **Let's Encrypt TLS certificates via cert-manager**
- ✅ **DNS records in Route53**

---

## 🚀 Features

- **EKS Cluster** with optional node groups and IAM configuration
- **Managed PostgreSQL** via Amazon RDS
- **NGINX Ingress Controllers**:
  - Public ingress for internet-facing traffic
  - Private ingress for internal services
- **TLS Certificates** from Let's Encrypt using `cert-manager`
- **DNS Automation** using AWS Route53

---

## 🧱 Prerequisites

Before using this module, ensure the following are in place: