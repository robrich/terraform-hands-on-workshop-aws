# Use the correct Docker image reference:

Make sure that the Docker image reference does not contain the full URL (https://hub.docker.com/).

Instead, Docker images hosted on Docker Hub should be referenced using the format:
`repository/image_name:tag`

For example, for the image terraform-workshop in the robrich Docker Hub repository, the correct image reference is:
`robrich/terraform-workshop-aws:latest`
If no tag is specified, Docker will default to the latest tag.
