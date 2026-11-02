# This tells Terraform to read the application you already created in the portal
data "azuread_service_principal" "aws_sso_sp" {
  display_name = "AWS IAM Identity Center (successor to AWS Single Sign-On)"
}
