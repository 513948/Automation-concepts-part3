data "local_file" "glb_template" {
  filename = "${path.module}/glb.yaml"
}

resource "aws_cloudformation_stack" "GLBStack" {
  name          = "GLBStack"
  template_body = data.local_file.glb_template.content

   parameters = {
     Backend1 = "FILL IN AWS HERE"
     Backend2 = "FILL IN GCLOUD HERE"
   }
}
