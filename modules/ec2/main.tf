resource "aws_instance" "gitlab_runner" {
  ami           = var.ami_id  
  instance_type = var.instance_type 
  key_name      = var.key_pair

  user_data = base64encode(templatefile("${path.module}/ec2_config.sh", {
    REGISTRATION_TOKEN=var.registration_token
    NAME = "${var.name_prefix}-gitlab-runner"
  }))

  tags = {
    "Name"        = "${var.name_prefix}-gitlab-runner"
    "DevOps"      = var.devops_tag
    "Project"     = var.project_tag
    "Environment" = var.env_tag
  }
}