# --------------------------------------------
# Creates the main Virtual Private Cloud (VPC)
# Defines the IP range, enables DNS resolution and hostname assignment
# --------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"  # VPC IP range
  enable_dns_support   = true           # Enable DNS resolution inside the VPC
  enable_dns_hostnames = true           # Assign public DNS to instances launched in the VPC

  tags = {
    Name = "main-vpc"  # Tag name for easy identification
  }
}

# --------------------------------------------
# Creates a public subnet inside the VPC
# Enables auto-assign of public IPs to launched resources
# --------------------------------------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id  # Associates the subnet with the VPC
  cidr_block              = "10.0.1.0/24"    # Subnet IP range
  availability_zone       = "us-east-1a"     # AZ where the subnet will be created
  map_public_ip_on_launch = true             # Automatically assign public IPs

  tags = {
    Name = "public-subnet-1"  # Tag for subnet identification
  }
}

# --------------------------------------------
# Creates an Internet Gateway (IGW)
# Allows outbound internet access for the VPC
# --------------------------------------------
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id  # Attaches the Internet Gateway to the VPC

  tags = {
    Name = "main-igw"  # Tag for identification
  }
}

# --------------------------------------------
# Creates a Route Table for public traffic
# Adds a default route (0.0.0.0/0) to the Internet Gateway
# --------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id  # Associates the route table with the VPC

  route {
    cidr_block = "0.0.0.0/0"  # Allows all outbound traffic
    gateway_id = aws_internet_gateway.main_igw.id  # Routes traffic to the Internet Gateway
  }

  tags = {
    Name = "public-route-table"  # Tag for identification
  }
}

# --------------------------------------------
# Associates the public subnet with the route table
# Allows the subnet to use the internet route
# --------------------------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_1.id      # Subnet to attach
  route_table_id = aws_route_table.public_rt.id # Route table to associate
}
