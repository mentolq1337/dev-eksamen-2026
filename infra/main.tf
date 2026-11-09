terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.23"
    }
  }

  backend "s3" {
    bucket = "pgr301-terraform-state"
    key    = "wishifai/20/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "uploads" {
  bucket = "wishifai-uploads-20"
}

variable "image_tag" {
  default = "latest"
}

resource "aws_iam_role" "task" {
  name = "wishifai-task-role-20"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "task" {
  role = aws_iam_role.task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = ["s3:PutObject", "s3:GetObject"], Resource = "${aws_s3_bucket.uploads.arn}/*" },
      { Effect = "Allow", Action = ["rekognition:DetectLabels"], Resource = "*" },
      { Effect = "Allow", Action = ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"], Resource = "*" }
    ]
  })
}

resource "aws_ecs_express_gateway_service" "app" {
  service_name            = "wishifai-20"
  execution_role_arn      = "arn:aws:iam::244530008913:role/ecsTaskExecutionRole"
  infrastructure_role_arn = "arn:aws:iam::244530008913:role/service-role/ecsInfrastructureRoleForExpressServices"
  task_role_arn           = aws_iam_role.task.arn
  health_check_path       = "/api/health"

  primary_container {
    image          = "244530008913.dkr.ecr.eu-west-1.amazonaws.com/wishifai-tomek:${var.image_tag}"
    container_port = 8080

    environment {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.uploads.bucket
    }
  }

  depends_on = [aws_iam_role_policy.task]
}

output "service_url" {
  value = aws_ecs_express_gateway_service.app.ingress_paths[0].endpoint
}