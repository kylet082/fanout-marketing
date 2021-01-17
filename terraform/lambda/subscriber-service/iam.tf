data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.workflow_name}-subscriber-service-lambda-policy"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
     {
        "Effect": "Allow",
        "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Sid": "SecretAccess",
      "Effect": "Allow",
      "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
      ],
      "Resource" : "arn:aws:secretsmanager:eu-west-1:${data.aws_caller_identity.current.account_id}:secret:${var.workflow_name}/subscriber/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.workflow_name}-subscriber-service-lambda-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

