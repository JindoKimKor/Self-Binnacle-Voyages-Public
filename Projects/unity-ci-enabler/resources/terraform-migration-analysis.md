# Terraform Migration Analysis

## Overview

This document analyzes the migration from Azure SDK to Terraform for the Unity CI Enabler project.

---

## Current Architecture (All SDK)

```mermaid
flowchart TB
    subgraph AF["Azure Functions (vmManager.js)"]
        direction TB
        REQ[Request] --> RG["ensureResourceGroup ❌"]
        RG --> VNET["createVirtualNetwork ❌"]
        VNET --> IP[createPublicIP]
        IP --> NSG["createNSG ❌"]
        NSG --> NIC[createNIC]
        NIC --> VM[createVM]
    end
```

**Legend:**
- ❌ Redundant work (recreated every request)

**Timeline per VM request:**

| Step | Resource Group | VNet | Public IP | NSG | NIC | VM |
|------|----------------|------|-----------|-----|-----|-----|
| Time | ~2s | ~5s | ~3s | ~3s | ~3s | ~60s |

**Total: ~76 seconds**

---

## Proposed Architecture (Hybrid: Terraform + SDK)

```mermaid
flowchart TB
    subgraph TF["Terraform (Run Once) ✅"]
        direction TB
        TF_RG[azurerm_resource_group]
        TF_VNET[azurerm_virtual_network]
        TF_SUBNET[azurerm_subnet]
        TF_NSG[azurerm_network_security_group]
        TF_OUT[outputs: subnet_id, nsg_id]

        TF_RG --> TF_VNET
        TF_VNET --> TF_SUBNET
        TF_SUBNET --> TF_NSG
        TF_NSG --> TF_OUT
    end

    subgraph AF["Azure Functions (vmManager.js - Simplified)"]
        direction TB
        REQ[Request] --> IP[createPublicIP]
        IP --> NIC[createNIC]
        NIC --> VM[createVM]
    end

    TF_OUT -.->|subnet_id, nsg_id| NIC
```

**Legend:**
- ✅ Terraform managed (created once, reused)
- SDK managed (dynamic, per request)

**Timeline per VM request:**

| Step | Public IP | NIC | VM |
|------|-----------|-----|-----|
| Time | ~3s | ~3s | ~60s |

**Total: ~66 seconds (-13%)**

---

## Efficiency Comparison

```mermaid
graph LR
    subgraph Before["Before (SDK Only)"]
        B1[76s per VM]
        B2[No state tracking]
        B3[Manual cleanup]
        B4[Redundant VNet/NSG creation]
    end

    subgraph After["After (Terraform + SDK)"]
        A1[66s per VM]
        A2[State file tracking]
        A3[terraform destroy]
        A4[VNet/NSG reused]
    end

    Before -->|Migration| After
```

| Aspect | Before (SDK Only) | After (Terraform + SDK) |
|--------|-------------------|-------------------------|
| **VM Creation Time** | ~76s | ~66s (-13%) |
| **Redundant Work** | VNet/NSG created every request | None (reused) |
| **State Tracking** | None | Terraform state |
| **Cleanup** | Manual | `terraform destroy` |
| **Scalability** | Code complexity increases | Modular |

---

## Where Efficiency Gains Occur

```mermaid
%%{init: {'theme': 'base'}}%%
mindmap
  root((Efficiency Gains))
    Time Savings
      -10s per VM
      Skip VNet/NSG creation
      Short-term benefit
    State Management
      Track infrastructure
      Drift detection
      Easy destroy
      Medium-term benefit
    Scale Readiness
      Add Batch as module
      Add SIG as module
      Add Storage as module
      Multi-cloud expansion
      Long-term benefit
```

---

## Resource Mapping: SDK to Terraform

| SDK Function | Terraform Resource | Migration |
|--------------|-------------------|-----------|
| `ensureResourceGroup()` | `azurerm_resource_group` | Terraform |
| `createVirtualNetwork()` | `azurerm_virtual_network` + `azurerm_subnet` | Terraform |
| `createNetworkSecurityGroup()` | `azurerm_network_security_group` | Terraform |
| `createPublicIP()` | - | Keep SDK |
| `createNetworkInterface()` | - | Keep SDK |
| `createVirtualMachine()` | - | Keep SDK |

---

## Multi-cloud Expansion Path

```mermaid
flowchart LR
    subgraph Azure
        AZ_TF[terraform/azure/]
        AZ_FN[Azure Functions]
        AZ_TF --> AZ_FN
    end

    subgraph AWS
        AWS_TF[terraform/aws/]
        AWS_LB[Lambda]
        AWS_TF --> AWS_LB
    end

    subgraph GCP
        GCP_TF[terraform/gcp/]
        GCP_CF[Cloud Functions]
        GCP_TF --> GCP_CF
    end

    SHARED[Shared: cloud-init script] -.-> Azure
    SHARED -.-> AWS
    SHARED -.-> GCP
```

---

## Decision Rationale

**Summary**: Proactive IaC adoption for multi-cloud expansion and increasing infrastructure complexity

| Reason | SDK Limitation | Terraform Solution |
|--------|----------------|-------------------|
| **Multi-cloud** | Need to learn/maintain SDK per cloud | Same HCL syntax, just swap providers |
| **State Management** | No resource tracking | State file tracks current infrastructure |
| **Cleanup** | Manual deletion required | `terraform destroy` auto-cleanup |
| **Scalability** | Complexity spikes with Batch, SIG, Storage | Modular management |
| **Collaboration** | Hard to understand infra from code alone | Code = Infrastructure documentation |

**Decision Context (2026-01-29)**:
- Current: 1 VM + network resources
- Planned: Azure Batch, SIG, Blob Storage, Static Website, Multi-cloud

**Hybrid Approach Rationale**:
- Static infrastructure (VNet, NSG, Storage): Terraform - create once, maintain long-term
- Dynamic resources (VM): Keep SDK - fast response needed in Serverless

---

## Implementation Phases

### Phase 1: Terraform Static Infrastructure
- `terraform/azure/main.tf` - Resource Group, VNet, Subnet, NSG
- `terraform/azure/variables.tf` - Variable definitions
- `terraform/azure/outputs.tf` - subnet_id, nsg_id for SDK

### Phase 2: Security Improvements
- Remove hardcoded passwords
- Add `.gitignore` for state files
- (Optional) Azure Key Vault integration

### Phase 3: SDK Refactoring
- Remove VNet/NSG creation from vmManager.js
- Reference Terraform outputs
- Simplify to dynamic VM creation only

### Phase 4: Multi-cloud Expansion
- `terraform/aws/` + Lambda
- `terraform/gcp/` + Cloud Functions
