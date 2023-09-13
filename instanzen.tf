resource "aws_instance" "master" {
  ami           = "ami-09cb21a1e29bcebf0"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnetz-oeffentlich.id}"
  vpc_security_group_ids = ["${aws_security_group.sg-aufgabe12sep.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "master"
  }
  #vorhandenen schlüssel wählen
  key_name = "key-nachhilfe"
}

resource "aws_instance" "slave" {
  ami           = "ami-09cb21a1e29bcebf0"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnetz-oeffentlich.id}"
  vpc_security_group_ids = ["${aws_security_group.sg-aufgabe12sep.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "slave"
  }
  #vorhandenen schlüssel wählen
  key_name = "key-nachhilfe"
}

resource "aws_instance" "slave2" {
  ami           = "ami-09cb21a1e29bcebf0"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnetz-oeffentlich.id}"
  vpc_security_group_ids = ["${aws_security_group.sg-aufgabe12sep.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "slave2"
  }
  #vorhandenen schlüssel wählen
  key_name = "key-nachhilfe"
}

resource "aws_instance" "slave3" {
  ami           = "ami-09cb21a1e29bcebf0"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnetz-oeffentlich.id}"
  vpc_security_group_ids = ["${aws_security_group.sg-aufgabe12sep.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "slave3"
  }
  #vorhandenen schlüssel wählen
  key_name = "key-nachhilfe"
}