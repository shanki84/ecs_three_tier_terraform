resource "aws_iam_role" "ecs-node" {
  name = "${var.env}-ECS-Worker-NodeInstanceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs-policy" {
  name        = "${var.env}-ECS-Worker-NodeInstancePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-node-WorkerNodePolicy" {
  policy_arn = aws_iam_policy.ecs-policy.arn
  role       = "${aws_iam_role.ecs-node.name}"
}

# --- IAM policy for S3 to store statefile & DynamoDB for StateLocking --- #
resource "aws_iam_role" "StateLocking" {
  name = "${var.env}-StateLocking"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformStateLocking",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem"
            ],
            "Resource": "arn:aws:dynamodb:::table/${dynamodb-table}"
        },
        {
            "Sid": "AllowTerraformStateBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::${s3-bucket}"
        },
        {
            "Sid": "AllowTerraformStateFileAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::${bucket_path}/*"
      }
    }
  }
