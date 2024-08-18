sudo apt update -y
sudo apt-get upgrade -y
sudo apt-get install -y sshpass

mkdir -p /home/vagrant/kube-cluster
cp /vagrant/setup-kubemaster.sh /home/vagrant/kube-cluster/
sudo chmod +x /home/vagrant/kube-cluster/setup-kubemaster.sh
sudo chown -R vagrant:vagrant /home/vagrant

#CURRENTUSER=$(whoami)

#ssh-keygen -f ~/.ssh/$(whoami) -q -t rsa -N "vagrant" -b 4096 -v

#sshpass -p vagrant ssh-copy-id -f -i ~/.ssh/$(whoami).pub $(whoami)@kubenodeone
#sshpass -p vagrant ssh-copy-id -f -i ~/.ssh/$(whoami).pub $(whoami)@kubenodetwo