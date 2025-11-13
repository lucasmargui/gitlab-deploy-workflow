# Creates a Security Group to allow HTTP, SSH and all outbound traffic
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP (80) and SSH (22) inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id  # Associates this security group with the main VPC

  tags = {
    Name = "allow_http_ssh"  # Tag for easier identification in AWS console
  }
}

# ✅ Allows inbound HTTP (port 80) from any IPv4 address
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  # Allows public access over HTTP
  from_port         = 80           # HTTP port
  ip_protocol       = "tcp"        # Uses TCP protocol
  to_port           = 80
}

# ✅ Allows inbound HTTP (port 80) from any IPv6 address
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv6         = "::/0"  # Allows public HTTP access for IPv6
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# ✅ Allows inbound SSH (port 22) from any IPv4 address
# ⚠ WARNING: Open to the internet — restrict to your IP in production for better security
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  # Allows SSH from anywhere (not recommended for production)
  from_port         = 22           # SSH port
  ip_protocol       = "tcp"
  to_port           = 22
}

# ✅ Allows inbound SSH (port 22) from any IPv6 address
# ⚠ WARNING: Public SSH access — consider restricting for security best practices
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv6         = "::/0"  # Allows SSH from any IPv6 address
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allows all outbound traffic to any IPv4 address
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  # No outbound restriction for IPv4
  ip_protocol       = "-1"          # -1 allows all protocols
}

# Allows all outbound traffic to any IPv6 address
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv6" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv6         = "::/0"  # No outbound restriction for IPv6
  ip_protocol       = "-1"     # Allows all protocols
}
