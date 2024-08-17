sudo apt update -y
sudo apgt-get upgrade -y

ssh-keygen -f ~/.ssh/vagrant3 -q -t rsa -N ""

sshpass -v -p vagrant ssh-copy-id -f -i /home/vagrant/.ssh/vagrant3.pub vagrant@kubenodeone
sshpass -v -p vagrant ssh-copy-id -f -i /home/vagrant/.ssh/vagrant3.pub vagrant@kubenodetwo