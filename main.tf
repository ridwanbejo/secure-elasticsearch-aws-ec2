resource "aws_vpc" "test-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-test-vpc"
  }
}

resource "aws_subnet" "test-subnet-public" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-test-subnet-public"
  }
}

resource "aws_route_table" "test-rt-public" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "${var.project}-test-rt-public"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "${var.project}-test-igw"
  }
}

resource "aws_route" "test-public-igw-route" {
  gateway_id             = aws_internet_gateway.test-igw.id
  route_table_id         = aws_route_table.test-rt-public.id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "test-rta-public" {
  subnet_id      = aws_subnet.test-subnet-public.id
  route_table_id = aws_route_table.test-rt-public.id
}

resource "aws_security_group" "default_public" {
  name        = "${var.project}_default_public_${var.region_code}"
  description = "${var.project} default public ${var.region_code}"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port   = 9200
    to_port     = 9400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Elasticsearch default http access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}_public_sg"
  }
}

resource "aws_key_pair" "singapore-region-key-pair" {
    key_name = "singapore-region-key-pair"
    public_key = "${file(var.public_key_path)}"
}

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

resource "aws_instance" "secure-elasticsearch" {
  ami           = "ami-0e763a959ec839f5e"
  instance_type = "t2.micro"
  
  tags = {
    Name = "${var.project}-elasticsearch-${random_id.instance_name_suffix.hex}"
  }

  subnet_id = aws_subnet.test-subnet-public.id

  key_name = aws_key_pair.singapore-region-key-pair.id

  connection {
      user = "${var.EC2_USER}"
      private_key = "${file("${var.private_key_path}")}"
  }

  security_groups = [ "${aws_security_group.default_public.id}" ] 
}

/*

resource "aws_instance" "secure-elasticsearch-data-1" {
  ami           = "ami-0e763a959ec839f5e"
  instance_type = "t2.micro"
  
  tags = {
    Name = "${var.project}-elasticsearch-data-1-${random_id.instance_name_suffix.hex}"
  }

  subnet_id = aws_subnet.test-subnet-public.id

  key_name = aws_key_pair.singapore-region-key-pair.id

  connection {
      user = "${var.EC2_USER}"
      private_key = "${file("${var.private_key_path}")}"
  }

  security_groups = [ "${aws_security_group.default_public.id}" ] 
}

resource "aws_instance" "secure-elasticsearch-data-2" {
  ami           = "ami-0e763a959ec839f5e"
  instance_type = "t2.micro"
  
  tags = {
    Name = "${var.project}-elasticsearch-data-2-${random_id.instance_name_suffix.hex}"
  }

  subnet_id = aws_subnet.test-subnet-public.id

  key_name = aws_key_pair.singapore-region-key-pair.id

  connection {
      user = "${var.EC2_USER}"
      private_key = "${file("${var.private_key_path}")}"
  }

  security_groups = [ "${aws_security_group.default_public.id}" ] 
}

*/