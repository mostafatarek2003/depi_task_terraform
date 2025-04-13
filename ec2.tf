resource "aws_instance" "ec2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name = aws_key_pair.moustafa_key.key_name

  
  tags = {
    Name = "web-server-ec2"
  }



user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2
              sudo systemctl start apache2
              echo "Hello, World" > /var/www/html/index.html
              EOF
}



resource "aws_key_pair" "moustafa_key" {
  key_name   = "moustafa-key"
  public_key = file("~/.ssh/id_ed25519.pub")
 
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.web_vpc.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}