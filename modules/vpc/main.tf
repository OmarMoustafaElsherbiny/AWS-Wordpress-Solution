locals {
  subnet = {
    for i in var.azs : i => {
      availability_zone    = i
      cidr_block = cidrsubnet(var.cidr, 8, i)
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.subnet

  vpc_id = ""
  

}
