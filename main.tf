# Create a VPC
resource "aws_vpc" "myVPC" {
  cidr_block           = "10.123.0.0/16"    # Allowable block size is between a /16  and /28 netmask (giving 65,536 and 16 IP addresses, respectively)
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}


# Create a subnet
resource "aws_subnet" "myVPC_public_subnet" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "dev-public"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "myVPC_internet_gateway" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "dev-igw"
  }
}

# Create Route Table
resource "aws_route_table" "myVPC_public_rt" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "dev-public_rt"
  }
}

# Create the default route
resource "aws_route" "myVPC_default_rt" {
  route_table_id = aws_route_table.myVPC_public_rt.id

  # Ensure all ip addresses head for this gateway
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myVPC_internet_gateway.id
}

# Create a route table assoication to bridge the gap between the route table and subnet
resource "aws_route_table_association" "myVPC_public_assoc" {
  subnet_id      = aws_subnet.myVPC_public_subnet.id
  route_table_id = aws_route_table.myVPC_public_rt.id
}

# Create the security group
resource "aws_security_group" "myVPC_security_group" {
  name        = "dev_sg"
  description = "dev decurity group"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    from_port = 0
    to_port   = 0
    # permit any protocol
    protocol = "-1"
    # hardcode (for testing) the cidr to your public IP address for now - '/32' only allows the specific address
    cidr_blocks = ["xx.xx.xx.xx/32"]
  }

  egress {
    from_port = 0
    to_port   = 0
    # permit any protocol
    protocol = "-1"
    # allow access to the open internet
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a key pair for the VPC's public key
resource "aws_key_pair" "myVPC_auth" {
  key_name   = "myVPCkey"
  public_key = file("~/.ssh/myVPCkey.pub")
}

# Create an EC2 instance
resource "aws_instance" "dev_node" {
  ami                    = data.aws_ami.myServer_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.myVPC_auth.key_name
  vpc_security_group_ids = [aws_security_group.myVPC_security_group.id]
  subnet_id              = aws_subnet.myVPC_public_subnet.id
  user_data              = file("userdata.tpl") # script to bootstrap the instance with an installation of Docker; note - if the script changes, it is re-deployed in the next Terraform apply automatically

  root_block_device {
    volume_size = 10 # up to 16 keeps you in the free tier; 8 is the default
  }

  tags = {
    Name = "dev.node"
  }

  # Uodate the local SSH confg (~/.ssh/config) with access details for the new EC2 instance
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname = self.public_ip,
      user = "ubuntu",
      identityfile = "~/.ssh/myVPCkey"
    })

    interpreter = var.host_os == "mac" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }

}
