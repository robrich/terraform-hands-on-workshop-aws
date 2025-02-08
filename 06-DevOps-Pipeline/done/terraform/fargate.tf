// Inspired by:
// https://www.chakray.com/creating-fargate-ecs-task-aws-using-terraform/
// https://erik-ekberg.medium.com/terraform-ecs-fargate-example-1397d3ab7f02
// https://medium.com/@olayinkasamuel44/using-terraform-and-fargate-to-create-amazons-ecs-e3308c1b9166

// the container definition
resource "aws_ecs_task_definition" "fargate_task" {
  family = local.fargate_task_name
  container_definitions = jsonencode([
    {
      name                          = local.fargate_task_name
      image                         = var.CONTAINER_IMAGE
      docker_authentication_enabled = false
      essential                     = true
      portMappings = [
        {
          containerPort = local.fargate_container_port
          hostPort      = local.fargate_container_port
        }
      ]
      environment = [for key, value in local.environment_variables : { "name" = key, "value" = value }]
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = "ecs/${local.fargate_task_name}"
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  task_role_arn = aws_iam_role.fargate_role.arn

  # must match a standard configuration:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu    = 256
  memory = 512

  tags = var.tags
}

// the instance(s) of the container
resource "aws_ecs_service" "fargate_service" {
  name            = local.fargate_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  desired_count   = local.fargate_container_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [/*data.*/ aws_security_group.ecs_tasks.id]
    subnets          = [for s in /*data.*/ aws_subnet.private : s.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target.id
    container_name   = local.fargate_task_name
    container_port   = local.fargate_container_port
  }

  depends_on = [
    aws_alb_listener.front_end,
    aws_iam_role_policy_attachment.fargate_role_policy_attachment
  ]

  tags = var.tags
}

# the cluster to run the containers in
resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.fargate_cluster_name

  tags = var.tags
}

# the role for the fargate task
resource "aws_iam_role" "fargate_role" {
  name               = "${local.fargate_task_name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "fargate_policy" {
  name   = "${local.fargate_task_name}-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "logging",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    },{
      "Sid": "DynamoDBTableAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:ConditionCheckItem",
        "dynamodb:PutItem",
        "dynamodb:DescribeTable",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": "${aws_dynamodb_table.dynamodb_table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fargate_role_policy_attachment" {
  policy_arn = aws_iam_policy.fargate_policy.arn
  role       = aws_iam_role.fargate_role.name
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.fargate_task_name}"
  retention_in_days = local.fargate_log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "${local.fargate_task_name}-stream"
  log_group_name = aws_cloudwatch_log_group.this.name
}
