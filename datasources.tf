data "aws_ami" "myServer_ami" {
  most_recent = true
  owners      = ["099720109477"] # sourced from EC2's AMI catalogue entry for the required AMI

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # sourced from the AMI entry; ignore date at end of the AMI name as we're looking for the most recent version
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # sourced from the AMI entry; ignore date at end of the AMI name as we're looking for the most recent version
  }
}
