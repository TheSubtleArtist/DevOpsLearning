#!/bin/bash

      sudo apt-get update -y
      sudo apt-get install -y maven vim openjdk-8-jdk
      sudo apt-get install ca-certificates curl -y
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      #Install "Latest"
      sudo apt-get install -y docker-compose docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo apt-get upgrade -y
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo usermod -aG docker vagrant
      # Verify
      sudo systemctl status docker
      sudo docker run hello-world


    echo 'y' | sudo ufw enable
    sudo ufw allow 22/tcp
    sudo ufw reload
