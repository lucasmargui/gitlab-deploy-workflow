# Creates an EC2 instance and attaches the previously created Security Group
resource "aws_instance" "amb-prod" {
  ami           = "ami-0ecb62995f68bb549"  # Amazon Machine Image
  instance_type = "t3.micro"               # Instance size/type
  key_name      = "Terraform"              # SSH Key pair to access the instance


  user_data = file("script.sh")

    # ✅ Put the instance inside the correct VPC subnet
  subnet_id = aws_subnet.public_1.id

  # ✅ Attaches the Security Group created in another file
  vpc_security_group_ids = [
    aws_security_group.allow_http_ssh.id
  ]

  tags = {
    Name = "amb-prod"  # EC2 instance name tag
  }
}
