resource "aws_iam_role" "external-dns" {
  name = "${local.name}-pod-role-for-external-dns"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Principal": {
          "Federated": "arn:aws:iam::739561048503:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/425BA7CE0D854F12026FA6444CF6F673"
        },
        "Condition": {
          "StringEquals": {
            "oidc.eks.us-east-1.amazonaws.com/id/425BA7CE0D854F12026FA6444CF6F673:aud": "sts.amazonaws.com"
            "oidc.eks.us-east-1.amazonaws.com/id/425BA7CE0D854F12026FA6444CF6F673:aud": "system:serviceaccount:default:external-dns"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "parameter-store"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Route53Access",
          "Effect" : "Allow",
          "Action" : [
            "route53:*"
          ],
          "Resource" : "*"
        }
      ]
    })
  }

}

