sudo apt update -y
sudo apt-get upgrade -y
sudo apt-get install -y unzip git

# INSTALL ANSIBLE
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

ANSIBLE_FILES=('inventory.ini' 'setup-controller.yml' 'setup-dependencies.yml' 'setup-system.yml' 'setup-workers.yml' 'ansible.cfg')
for file in "${ANSIBLE_FILES[@]}"; do
    cp /vagrant/$file /home/vagrant/
done

sudo chown -R vagrant:vagrant /home/vagrant