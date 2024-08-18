sudo apt update -y
sudo apt-get upgrade -y
sudo apt-get install -y unzip git

# INSTALL ANSIBLE
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
cd /home/vagrant/kube-cluster