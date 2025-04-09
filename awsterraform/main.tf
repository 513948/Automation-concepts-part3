# UNTESTED

# AZ
data "local_file" "az_template" {
  filename = "${path.module}/az.yaml"
}

resource "aws_cloudformation_stack" "AZStack" {
  name          = "AZStack"
  template_body = data.local_file.az_template.content
}



# RDS
data "local_file" "rds_template" {
  filename = "${path.module}/rds.yml"
}

resource "aws_cloudformation_stack" "RDSStack" {
  name          = "DatabaseStack"
  template_body = data.local_file.rds_template.content

   parameters = {
     DBUsername = "TestTest"
     DBPassword = "TestTest"
   }

depends_on = [aws_cloudformation_stack.AZStack]
}



# LB
data "local_file" "lb_template" {
  filename = "${path.module}/lb.yml"
}

resource "aws_cloudformation_stack" "LBStack" {
  name          = "LBStack"
  template_body = data.local_file.lb_template.content

depends_on = [aws_cloudformation_stack.RDSStack]
}



# EFS
data "local_file" "efs_template" {
  filename = "${path.module}/efs.yml"
}

resource "aws_cloudformation_stack" "EFSStack" {
  name          = "EFSStack"
  template_body = data.local_file.efs_template.content

depends_on = [aws_cloudformation_stack.LBStack]
}



# ECR
data "local_file" "ecr_template" {
  filename = "${path.module}/ecr.yml"
}

resource "aws_cloudformation_stack" "ECRStack" {
  name          = "ECRStack"
  template_body = data.local_file.ecr_template.content

depends_on = [aws_cloudformation_stack.ECRStack]
capabilities = ["CAPABILITY_NAMED_IAM"]
}



# BS
data "local_file" "bs_template" {
  filename = "${path.module}/bs.yml"
}

resource "aws_cloudformation_stack" "BSStack" {
  name          = "BSStack"
  template_body = data.local_file.bs_template.content

depends_on = [aws_cloudformation_stack.ECRStack]
capabilities = ["CAPABILITY_NAMED_IAM"]
}



# ASG
data "local_file" "asg_template" {
  filename = "${path.module}/asg.yml"
}

resource "aws_cloudformation_stack" "ASGStack" {
  name          = "ASGStack"
  template_body = data.local_file.asg_template.content

depends_on = [aws_cloudformation_stack.BSStack]
}



# ELK
data "local_file" "elk_template" {
  filename = "${path.module}/elk.yml"
}

resource "aws_cloudformation_stack" "ELKStack" {
  name          = "ELKStack"
  template_body = data.local_file.elk_template.content

depends_on = [aws_cloudformation_stack.ASGStack]
}



# exp
data "local_file" "exp_template" {
  filename = "${path.module}/exp.yml"
}

resource "aws_cloudformation_stack" "EXPStack" {
  name          = "EXPStack"
  template_body = data.local_file.exp_template.content

depends_on = [aws_cloudformation_stack.ELKStack]
capabilities = ["CAPABILITY_NAMED_IAM"]
}
