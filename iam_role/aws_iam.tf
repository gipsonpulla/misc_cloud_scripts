resource "aws_iam_role" "my-test-iam-role" {
    name = "my-test-iam-role"
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
    }
    ]
    }
    EOF
}

resource "aws_iam_instance_profile" "my-test-iam-instance-profile" {
    name = "my-test-iam-instance-profile"
    role = "${aws_iam_role.my-test-iam-role}"
}

resource "aws_iam_role_policy" "my-test-policy" {
    name = "my-test-iam-policy"
    role = "${aws_iam_role.my-test-iam-role.id}"
    policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "GrantS3Access",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject"
                ],
            "Resource": [
            "gipson_arn_bucket",
            ]
        }
    ]
}
EOF
}

resource "aws_instance" "test_ec2_role" {
    ami = "ami-ererere"
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.my-test-iam-instance-profile}"
    key_name = "gipson_k8x.key"
}

# terraform init
# terraform plan
# terraform apply -auto-approve