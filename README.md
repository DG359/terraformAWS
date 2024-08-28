# terraformAWS

Provision an EC2 instance using Terraform and then install Docker

# Prerequisites:

- terraform installed on your local machine
- AWS account

# Steps

# 1 - initialise the Terraform project

    $ terraform init

# 2 - configure main.tf to:

    - create a VPC
    - create its subnet and internet gateway
    - create the routing table and default route
    - bridge the routing table and subnet
    - create tge security group
    - create a key pair for the VPC's public key
    - creaate an EC2 instance
    - (optional)

    Notes: for now, the security is configured to restrict ingrees from a hardcoded IP address; set this to your local IP

# 3 - check the terraform plan

    $ terraform plan

# 4 - provision the infra

    $ terraform apply

    Notes:
    - outputs include the public IP address of and ID of the new E2C instance (ref. dev_ip, EC2_instance_id, respectively).  see outputs.tf

    - you can view these variables using: $ terraform output

    - You can connect to this instance using SSH

# 5 - tear down the infra

    $ terrafor destroy
