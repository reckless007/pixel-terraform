data "aws_acm_certificate" "cert_global" {
  domain = "*.ethoshdemo.in"
  statuses = ["ISSUED"] 
}

#EC2 Instance
resource "aws_instance" "myFirstInstance" {
  count = var.number_of_instances
  ami           = var.AMI
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups  = ["security_pixel_sg"]
  tags= {
    Name = "PixelTerraform-${count.index}"
  }
  user_data = <<-EOF
              #!/bin/bash
              /home/ubuntu/PixelStreaming/PixelStreaming/containers.sh
              EOF  
}

#EC2 Security Group
resource "aws_security_group" "security_pixel_sg" {
  name        = var.ec2_sg
  description = "security group for Pixel streaming"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "security_pixel_sg"
  }
}

#Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "subnet" {
  vpc_id = "${aws_default_vpc.default.id}"
  
}

#Target Groups and Attachment
resource "aws_lb_target_group" "my-pixel-group" {
  health_check {
    interval            = 10
    path                = "/nginx-health"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = var.ec2_target_group
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${aws_default_vpc.default.id}"
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
}

resource "aws_lb_target_group_attachment" "my_pixel_ec2_0" {
  count = var.number_of_instances
  target_group_arn = aws_lb_target_group.my-pixel-group.arn
  target_id        = aws_instance.myFirstInstance[count.index].id
  #for_each = toset(var.port_numbers)
  port =  var.port_numbers[0]
  #port             = [for u in var.port_numbers : u.index] 
}
resource "aws_lb_target_group_attachment" "my_pixel_ec2_1" {  
  count = var.number_of_instances
  target_group_arn = aws_lb_target_group.my-pixel-group.arn
  target_id        = aws_instance.myFirstInstance[count.index].id
  #for_each = toset(var.port_numbers)
  port =  var.port_numbers[1]
  #port             = [for u in var.port_numbers : u.index] 
}
resource "aws_lb_target_group_attachment" "my_pixel_ec2_2" {
  count = var.number_of_instances
  target_group_arn = aws_lb_target_group.my-pixel-group.arn
  target_id        = aws_instance.myFirstInstance[count.index].id
  #for_each = toset(var.port_numbers)
  port =  var.port_numbers[2]
  #port             = [for u in var.port_numbers : u.index] 
}
resource "aws_lb_target_group_attachment" "my_pixel_ec2_3" {
  count = var.number_of_instances
  target_group_arn = aws_lb_target_group.my-pixel-group.arn
  target_id        = aws_instance.myFirstInstance[count.index].id
  #for_each = toset(var.port_numbers)
  port =  var.port_numbers[3]
  #port             = [for u in var.port_numbers : u.index] 
}


#Load Balancer
resource "aws_lb" "test" {
  name               = var.ec2_lbname
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_pixel_sg.id]
  ip_address_type = "ipv4"
  subnets            = data.aws_subnet_ids.subnet.ids

}

resource "aws_lb_listener" "forport_80" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "forport_443" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert_global.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-pixel-group.arn
  }
}
