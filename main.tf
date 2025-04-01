resource "aws_security_group" "ark_sg" {
  name        = "ark-security-group"
  description = "Security group para o servidor ARK"

  # Permitir conexões do jogo (porta 7777 e 27015 UDP)
  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27015
    to_port     = 27015
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH para administração
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ark_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ark_key.key_name
  security_groups = [aws_security_group.ark_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt install -y steamcmd awscli
              sudo add-apt-repository multiverse; sudo dpkg --add-architecture i386; sudo apt update
              sudo apt install steamcmd
              mkdir -p /home/ubuntu/ark-server
              cd /home/ubuntu/ark-server
              steamcmd +login anonymous +force_install_dir /home/ubuntu/ark-server +app_update 376030 validate +quit
              nohup /home/ubuntu/ark-server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen -server -log &
              
              # Configuração de Backup para o S3
              echo "0 3 * * * tar -czvf /home/ubuntu/ark-backup.tar.gz /home/ubuntu/ark-server && aws s3 cp /home/ubuntu/ark-backup.tar.gz s3://${var.s3_bucket_name}/" | crontab -
              EOF

  tags = {
    Name = "ARK-Server"
  }
}

output "instance_ip" {
    description = "The public IP address of the ARK server instance"
    value       = aws_instance.ark_server.public_ip
}