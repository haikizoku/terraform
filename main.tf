
resource "aws_key_pair" "admin" {
   key_name   = "admin"
   public_key ="${file("ssh-key/id_rsa_aws.pub")}"
}

resource "aws_security_group" "instance_sg" {
    name = "securityGroup-Terraform-sg"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
 }

resource "aws_instance" "terraform_tp" {
    ami = "ami-0d2a4a5d69e46ea0b"
    instance_type = "t2.micro"
    key_name  = "admin"
    vpc_security_group_ids =[aws_security_group.instance_sg.id]

    user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>hello </h1>" >  /var/www/html/index.html
EOF

}