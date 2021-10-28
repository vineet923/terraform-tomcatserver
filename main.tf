variable "ingressrules" {
  type    = list(number)
  default = [8080, 22]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "inbound ports for ssh and standard http and everything outbound"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Terraform" = "true"
  }
}

# resource block

resource "aws_instance" "tomcat" {
  ami             = var.AMIS[var.REGION]
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "jenkins-server-key"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git maven java-1.8.0-openjdk",
      "sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.tar.gz",
      "tar -xvzf apache-tomcat-9.0.54.tar.gz",
      "mv apache-tomcat-9.0.54 tomcat9",
      "cd /home/ec2-user/tomcat9/bin",
      "./startup.sh",
      "cd /home/ec2-user",
      "mkdir vk",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("${path.module}/jenkins-server-key.pem")
  }
  tags = {
    "Name" = "tomcat server"
  }
}
