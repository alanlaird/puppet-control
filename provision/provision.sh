#!/bin/bash

PE_VERSION="3.8.0"

###########################################################
ANSWERS=$1
PE_URL="https://s3.amazonaws.com/pe-builds/released/${PE_VERSION}/puppet-enterprise-${PE_VERSION}-el-6-x86_64.tar.gz"
FILENAME=${PE_URL##*/}
DIRNAME=${FILENAME%*.tar.gz}

## A reasonable PATH
echo "export PATH=$PATH:/usr/local/bin:/opt/puppet/bin" >> /etc/bashrc

## Add host entries for each system
cat > /etc/hosts <<EOH
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain
::1 localhost localhost.localdomain localhost6 localhost6.localdomain
192.168.137.10 xmaster.vagrant.vm xmaster puppet
192.168.137.14 xagent.vagrant.vm xagent
EOH

# turn off iptables
/sbin/service iptables stop

# download and full install only happens on master
if [ "$1" == 'master.txt' ]; then
  ## Download and extract the PE installer
  cd /vagrant/provision/pe || (echo "/vagrant/provision/pe doesn't exist." && exit 1)
  if [ ! -f $FILENAME ]; then
    curl -O ${PE_URL} || (echo "Failed to download ${PE_URL}" && exit 1)
  else
    echo "${FILENAME} already present"
  fi

  if [ ! -d ${DIRNAME} ]; then
    tar zxf ${FILENAME} || (echo "Failed to extract ${FILENAME}" && exit 1)
  else
    echo "${DIRNAME} already present"
  fi

  ## Install PE with a specified answer file
  if [ ! -d '/opt/puppet/' ]; then
    # Assume puppet isn't installed
    /vagrant/provision/pe/${DIRNAME}/puppet-enterprise-installer \
      -a /vagrant/provision/pe/answers/${ANSWERS}
  else
    echo "/opt/puppet exists. Assuming it's already installed."
  fi


  ## Bootstrap the master

  /vagrant/provision/bootstrap_r10k.sh

  echo "All done! Now ssh in using vagrant ssh xmaster and sudo to root!"

else

  curl -k https://xmaster.vagrant.vm:8140/packages/current/install.bash  | bash

  echo "Finished! Access this instance using 'vagrant ssh xagent', sudo to root!"

fi
