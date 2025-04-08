

data "local_file" "az_template" {
  filename = "${path.module}/az.yaml"
}

resource "aws_cloudformation_stack" "AZStack" {
  name          = "AZStack"
  template_body = data.local_file.az_template.content
}

data "local_file" "rds_template" {
  filename = "${path.module}/rds.yml"
}

resource "aws_cloudformation_stack" "RDSStack" {
  name          = "RDSStack"
  template_body = data.local_file.rds_template.content

   parameters = {
     DBUsername = "TestTest"
     DBPassword = "TestTest"
   }

depends_on = [aws_cloudformation_stack.AZStack]
 # capabilities = ["CAPABILITY_NAMED_IAM"]  # Include this if your template creates IAM resources
}
