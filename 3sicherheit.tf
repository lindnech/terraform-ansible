 #SICHERHEITSGRUPPEN Für EC2

#Security Group für SSH-Zugriff erstellen
resource "aws_security_group" "sg-aufgabe12sep" {
  vpc_id = aws_vpc.vpc-aufgabe12sep.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Benötigte Protokolle für eine EC2 Instanz mit Web-Server:
  ingress {
    from_port   = 22 #SSH
    to_port     = 22
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80 #HTTP
    to_port     = 80
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443 #HTTPS
    to_port     = 443
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-aufgabe12sep"
  }
}