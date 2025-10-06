# resource "aws_alb" "this" {
#   name               = "sre-challenge-alb"
#   internal           = false #tfsec:ignore:aws-elb-alb-not-public
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [local.subnets.eks]
#
#   enable_deletion_protection = false
#   drop_invalid_header_fields = true
# }

# resource "aws_security_group" "alb_sg" {
#   name        = "sre-challenge-alb-sg"
#   description = "Security group for the ALB"
#   vpc_id      = aws_vpc.main.id
#
#   ingress {
#     description = "Allow HTTP traffic from anywhere"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-ingress-sgr
#   }
# }
# resource "aws_alb_target_group" "this" {
#   name     = "sre-challenge-alb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
#
#   health_check {
#     path                = "/health"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200-399"
#   }
# }

# resource "aws_alb_listener" "this" {
#   load_balancer_arn = aws_alb.this.arn
#   port              = "443"
#   protocol          = "HTTPS"
#
#   ssl_policy      = "ELBSecurityPolicy-TLS13-1-3-2021-06"
#   certificate_arn = aws_acm_certificate.this.arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.this.arn
#   }
# }

# Listener certificate
# resource "aws_acm_certificate" "this" {
#   domain_name       = "web.example.com"
#   validation_method = "DNS"
#   tags = {
#     Name = "sre-challenge-alb-cert"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }