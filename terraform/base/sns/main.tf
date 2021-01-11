resource "aws_sns_topic" "sns" {
  name = "${var.project_name}-${var.topic_name}"
}