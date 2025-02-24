resource "aws_instance" "payment" {
  ami = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0217d4c61f41d9ce7"]
  tags = {
    Name = "payment"
  }
}

resource "aws_route53_record" "payment" {
  name    = "payment-dev"
  type    = "A"
  zone_id = "Z0742899AVG59Z59WGO9"
  ttl = 10
  records = [aws_instance.payment.private_ip]
}

resource "null_resource" "payment" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.payment.private_ip
    }
    inline =[
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost, -U https://github.com/vadlasaiteja-git/roboshop-ansible roboshop.yml  -e component_name=payment -e env=dev"

    ]
  }
}