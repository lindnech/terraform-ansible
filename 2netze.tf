#VPCS UND SUBNETZE

# VPC erstellen und IGW hinzufügen
resource "aws_vpc" "vpc-aufgabe12sep" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "vpc-aufgabe12sep"
  }
}

# Öffentliches Subnetz erstellen
resource "aws_subnet" "subnetz-oeffentlich" {
  vpc_id                  = aws_vpc.vpc-aufgabe12sep.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true #bedeutet dass jede neue EC2 Instanz einen öffentlichen IP bekommt
  tags = {
    name = "subnetz-oeffentlich"
  }
}
#Routing tabellen öffentlich
resource "aws_route_table" "routing_table_oeffentlich" {
  vpc_id = aws_vpc.vpc-aufgabe12sep.id
  tags= {
    name = "routing_table_oeffentlich"
  }
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-aufgabe12sep.id}"
  }
}

resource "aws_internet_gateway" "igw-aufgabe12sep" {
  vpc_id = aws_vpc.vpc-aufgabe12sep.id
  
  tags = {
    name = "igw-aufgabe12sep"
  }
}

# Verknüpfung der öffentlichen Routing-Tabelle mit dem öffentlichen Subnetz
resource "aws_route_table_association" "aufgabe12sept-rt-regel" {
  subnet_id      = aws_subnet.subnetz-oeffentlich.id
  route_table_id = aws_route_table.routing_table_oeffentlich.id
}