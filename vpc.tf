resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.web_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}



resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name = "web-igw"
  }
}




resource "aws_route_table" "public_web_route_table" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_igw.id
  }

  tags = {
    Name = "public_web_route_table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id         = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_web_route_table.id
}