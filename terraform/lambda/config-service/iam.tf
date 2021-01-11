resource "aws_iam_role_policy" "lambda_policy" {
  name = ""
  role = ""
  policy = <<EOF
    {
      "Version" : "2012-10-17",
      "Statement" : [
         {
            "Effect": "Allow",
            "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogsStream",
                  "logs:PutLogEvents"
            ]
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid" : "S3_object_access"
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "*"
        }
      ]
    }
  EOF

}

resource "aws_iam_role" "lambda_role" {
  name = ""
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

