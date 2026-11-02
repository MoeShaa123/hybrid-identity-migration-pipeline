# Provisions the target SAML Provider endpoint inside AWS IAM
resource "aws_iam_saml_provider" "entra_id_trust" {
  name                   = "MicrosoftEntraID-IdP"
  
  # For absolute automation, we read the metadata XML exported from your Entra App
  # Ensure you save your Entra application SAML Metadata file as 'entra_metadata.xml' in this folder
  saml_metadata_document = file("${path.module}/entra_metadata.xml")
}

# IAM Role assumed by federated users executing out of Azure
resource "aws_iam_role" "federated_admin" {
  name = "AzureFederatedAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.entra_id_trust.arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://amazon.com"
          }
        }
      }
    ]
  })
}

# Attach AdministratorAccess policies to our test identity role
resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.federated_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
