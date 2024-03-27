resource "aws_route_table_association" "public" {
  # The ID of public subnet
  subnet_id = aws_subnet.public.id

  # The ID of public route table
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  # The ID of private subnet
  subnet_id = aws_subnet.private.id

  # The ID of private route table
  route_table_id = aws_route_table.private.id
}
