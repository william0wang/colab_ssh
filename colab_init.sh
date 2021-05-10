#!/bin/bash

# there should already be frpc.ini and authorized_keys files here
# usage: bash colab_init.sh <password_of_new_user>

# configure ssh
echo "### configuring ssh"
apt-get -qq update
apt-get -qq install ssh net-tools tmux mosh byobu screen vim libvulkan-dev
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "Port 23333" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config
# echo "LD_LIBRARY_PATH=/usr/lib64-nvidia" >> /root/.bashrc
# echo "export LD_LIBRARY_PATH" >> /root/.bashrc
service ssh restart

echo "### install conda3"
pip install --upgrade pip
MINICONDA_INSTALLER_SCRIPT=Miniconda3-py37_4.9.2-Linux-x86_64.sh
MINICONDA_PREFIX=/usr/local
wget https://repo.anaconda.com/miniconda/$MINICONDA_INSTALLER_SCRIPT
chmod +x $MINICONDA_INSTALLER_SCRIPT
./$MINICONDA_INSTALLER_SCRIPT -b -f -p $MINICONDA_PREFIX
conda update -y -n base -c defaults conda
conda clean --index-cache
conda init bash

wget wget https://github.com/nihui/srmd-ncnn-vulkan/releases/download/20210210/srmd-ncnn-vulkan-20210210-ubuntu.zip
unzip srmd-ncnn-vulkan-20210210-ubuntu.zip

# download frp
echo "### downloading frp"
frp_version=0.36.2
wget -q --show-progress -c https://github.com/fatedier/frp/releases/download/v${frp_version}/frp_${frp_version}_linux_amd64.tar.gz
tar xzf frp_${frp_version}_linux_amd64.tar.gz -C /opt/
mv /opt/frp_${frp_version}_linux_amd64 /opt/frp
mv frpc.ini /opt/frp/frpc.ini
chmod -R 755 /opt/frp
echo "### start frp"
killall frpc
nohup /opt/frp/frpc -c /opt/frp/frpc.ini &
rm -f frp_${frp_version}_linux_amd64.tar.gz
rm -f $MINICONDA_INSTALLER_SCRIPT
rm -rf srmd-ncnn-vulkan-20210210-ubuntu.zip
rm -f colab_init.sh

echo "### done"
