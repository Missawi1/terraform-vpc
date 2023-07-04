locals {
  /*availability_zones = {
    "us-east-1a" : "us-east-1a",
    "us-east-1b" : "us-east-1b",
    "us-east-1c" : "us-east-1c",
  }*/

  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidr_blocks = { 
    us-east-1a = "10.0.1.0/24"  
    us-east-1b = "10.0.2.0/24"  
    us-east-1c = "10.0.3.0/24"  
  }

  private_subnet_cidr_blocks = {
    us-east-1a = "10.0.7.0/24"  
    us-east-1b = "10.0.8.0/24"  
    us-east-1c = "10.0.9.0/24"  
  }
}