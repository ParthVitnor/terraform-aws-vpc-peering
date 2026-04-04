# VPC Peering Using Terraform

This project demonstrates how to establish VPC peering connections between two AWS VPCs using Terraform Infrastructure as Code (IaC). It creates a complete networking setup with two VPCs, subnets, EC2 instances, and a peering connection to enable secure communication between them.

## Overview

VPC peering allows you to route traffic between two VPCs using private IP addresses. This project sets up:
- Two VPCs (Primary and Secondary) with non-overlapping CIDR blocks
- Public subnets in each VPC with Internet Gateway access
- EC2 instances in both VPCs for testing connectivity
- VPC peering connection with automatic acceptance
- Route tables configured for cross-VPC communication
- Security groups allowing SSH and ICMP traffic between VPCs

## Architecture

```
Primary VPC (10.0.0.0/16)          Secondary VPC (11.0.0.0/16)
├── Subnet (10.0.1.0/24)           ├── Subnet (11.0.1.0/24)
├── Internet Gateway               ├── Internet Gateway
├── EC2 Instance                   ├── EC2 Instance
└── Security Group                 └── Security Group
            │                                │
            └────── VPC Peering ─────────────┘
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0)
- AWS Account with appropriate permissions
- AWS CLI configured with credentials
- SSH client for connecting to EC2 instances

## Resources Created

- 2 VPCs with DNS support enabled
- 2 Public subnets
- 2 Internet Gateways
- 2 Route tables with appropriate routes
- 2 EC2 instances (Ubuntu 22.04)
- 2 Security groups
- 1 VPC peering connection
- 1 SSH key pair (auto-generated)

## Configuration

### Default Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `region` | `ap-south-1` | AWS region for deployment |
| `primary_vpc_cidr_block` | `10.0.0.0/16` | CIDR block for primary VPC |
| `primary_subnet_cidr_block` | `10.0.1.0/24` | CIDR block for primary subnet |
| `secondary_vpc_cidr_block` | `11.0.0.0/16` | CIDR block for secondary VPC |
| `secondary_subnet_cidr_block` | `11.0.1.0/24` | CIDR block for secondary subnet |
| `subnet_availability_zone` | `ap-south-1a` | Availability zone for subnets |
| `instance_type` | `t3.micro` | EC2 instance type |
| `key_pair_name` | `instance-key-pair` | Name for SSH key pair |

You can customize these values by creating a `terraform.tfvars` file or passing them via command line.

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/ParthVitnor/terraform-aws-vpc-peering.git
cd vpc-peering-using-terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 5. Access the Outputs

After successful deployment, Terraform will output:
- Primary instance public IP
- Secondary instance public IP
- VPC peering connection status

### 6. Test Connectivity

SSH into the primary instance:
```bash
ssh -i ec2-key.pem ubuntu@<primary_instance_ip>
```

From the primary instance, ping the secondary instance's private IP:
```bash
ping <secondary_instance_private_ip>
```

## Security Considerations

- SSH access (port 22) is open to `0.0.0.0/0` - restrict this in production
- ICMP and TCP traffic allowed between VPCs for testing
- Root volumes are encrypted
- Security groups follow least privilege principle for inter-VPC communication

## Cleanup

To destroy all resources created by this project:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

## Outputs

- `primary_instance_ip`: Public IP address of the primary EC2 instance
- `secondary_instance_ip`: Public IP address of the secondary EC2 instance
- `vpc_peering_status`: Status of the VPC peering connection

## File Structure

```
.
├── main.tf           # Main infrastructure resources
├── variables.tf      # Variable definitions
├── outputs.tf        # Output definitions
├── provider.tf       # Provider configuration
├── README.md         # This file
└── ec2-key.pem       # Auto-generated SSH private key (created after apply)
```

## License

See the [LICENSE](LICENSE) file for details.

## Notes

- The SSH private key (`ec2-key.pem`) is automatically generated and saved locally
- Ensure you keep the private key secure and don't commit it to version control
- The project uses Ubuntu 22.04 LTS AMI (automatically fetches the latest version)
- Both VPCs have internet access via their respective Internet Gateways
