tags = {
  "project" = "terraform-workshop",
  "env"     = "YOUR_NAME_HERE" # <-- Change this
}
ENV_NAME        = "your_name_here" # <-- Change this
LAMBDA_ZIP_FILE = "../artifacts/terraform-lambda.zip"
CONTAINER_IMAGE = "robrich/terraform-workshop-aws:latest"

# TODO: must set as terminal env var:
# export AWS_PROFILE="my-aws-profile"
# $env:AWS_PROFILE = "my-aws-profile"
