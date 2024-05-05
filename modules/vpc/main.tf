resource "aws_vpc" "main" {
  
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.main.id
}