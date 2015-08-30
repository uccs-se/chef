#!/bin/bash

run_dir=`pwd -P`

#Get the absolute path of the script so we can load the external modules
pushd `dirname $0` > /dev/null
script_dir=`pwd -P`
popd > /dev/null

cd ${script_dir}
#TODO remove setting globals buy writing return values to std::out and capturing them.
source 'lib/prompt.sh' #user prompt utilities.
source 'lib/user.sh'   #*nix user manipulation library.
cd ${run_dir}

#TODO check if this is a supported linux distrobution.
hash sudo    2>/dev/null || { echo >&2 "sudo is required but is not installed.  Aborting."; exit_script='1'; }
hash apt-get 2>/dev/null || { echo >&2 "apt-get is required but is not installed.  Aborting."; exit_script='1'; }
hash rm      2>/dev/null || { echo >&2 "rm is required but is not installed.  Aborting."; exit_script='1'; }
hash wget    2>/dev/null || { echo >&2 "wget is required but is not installed.  Aborting."; exit_script='1'; }
hash dpkg    2>/dev/null || { echo >&2 "dpkg is required but is not installed.  Aborting."; exit_script='1'; }

if [ ${exit_script} -ne '0' ]; then
  exit ${exit_script};
fi

# Update Ubuntu
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install chef git build-essential wget

sudo mkdir '/var/chef-solo'
sudo git clone -b 'production' 'https://github.com/uccs-se/chef' '/var/chef-solo'
# Set up chef system control.
sudo chef-solo -c /var/chef-solo/cookbooks/se-chef-solo/files/solo.rb -j /var/chef-solo/cookbooks/se-chef-solo/files/production.json
# the rest is up to chef.