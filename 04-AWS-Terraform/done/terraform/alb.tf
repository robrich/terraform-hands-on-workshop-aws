
resource "aws_alb" "alb" {
  name            = local.alb_name
  subnets         = [for s in /*data.*/ aws_subnet.public : s.id]
  security_groups = [/*data.*/ aws_security_group.lb.id]

  tags = var.tags
}

resource "aws_alb_target_group" "alb_target" {
  name        = local.alb_name
  port        = local.fargate_container_port
  protocol    = "HTTP"
  vpc_id      = /*data.*/ aws_vpc.main.id
  target_type = "ip"

  // a static url in the container:
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = var.tags
}

# Reply to anything else
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.id
  port              = local.alb_public_port
  protocol          = "HTTP"

  // We've chosen to send a hard-coded response by default
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hello from the ALB!"
      status_code  = "200"
    }
  }
  /*
  // We could also directly route to the container
  // But we'll do that in the listener rule below instead
  default_action {
    target_group_arn = aws_alb_target_group.alb_target.id
    type             = "forward"
  }
  */

  tags = var.tags
}

# Send /api/* to the target group
resource "aws_lb_listener_rule" "path_routing" {
  listener_arn = aws_alb_listener.front_end.arn
  # from 1 to 50000, lower is first
  priority = 100

  action {
    target_group_arn = aws_alb_target_group.alb_target.id
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

  depends_on = [aws_alb_target_group.alb_target]
}
