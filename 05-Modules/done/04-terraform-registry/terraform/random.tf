# Only include lower-case alpha-numeric characters so we don't get naming errors in AWS or tfstate
resource "random_string" "workshop_randomness" {
  length  = 8
  special = false
  upper   = false
}
