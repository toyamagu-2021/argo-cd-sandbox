resource "aws_ecr_repository" "sample-app" {
  name                 = "${var.owner}/sample-app"
  image_tag_mutability = "MUTABLE"
}
