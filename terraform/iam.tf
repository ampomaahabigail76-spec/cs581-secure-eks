resource "aws_iam_policy" "backend_secrets_policy" {
  name        = "BackendSecretsPolicy"
  description = "Allow backend pods to read secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "arn:aws:secretsmanager:us-east-1:*:secret:cs581/*"
    }]
  })
}
# Enable EBS encryption by default for all future volumes
resource "aws_ebs_encryption_by_default" "enabled" {
  enabled = true
}
