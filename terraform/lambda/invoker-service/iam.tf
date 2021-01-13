resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.workflow_name}-invoker-service-lambda-policy"
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
        "Effect": "Allow",
        "Action": [
              "state:StartExecution"
        ],
        "Resource": [
          "${var.step_function_arn}"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.workflow_name}-invoker-service-lambda-role"
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

