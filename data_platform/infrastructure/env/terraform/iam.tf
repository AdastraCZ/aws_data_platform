/*****
* Glue IAM role for crawlers, jobs
*****/

resource "aws_iam_role" "glue_role" {
  name               = "glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue-assume-role-policy.json
}

data "aws_iam_policy_document" "glue-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "extra-policy" {
  name        = "glue-extra-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.extra-policy-document.json

}

data "aws_iam_policy_document" "extra-policy-document" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "extra-policy-attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.extra-policy.arn
}


resource "aws_iam_role_policy_attachment" "glue-service-role-attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = data.aws_iam_policy.AWSGlueServiceRole.arn
}

data "aws_iam_policy" "AWSGlueServiceRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
