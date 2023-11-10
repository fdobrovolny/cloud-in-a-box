#!/bin/bash

echo "INIT-CIAB"
set -x 

if [ -e /etc/init-ciab.params ];then
   param_file="/etc/init-ciab.params"
else
   param_file="/proc/cmdline"
fi

vars="$(tr ' ' '\n' < $param_file |grep -P '^ciab_.+=.+')"
if [ -n "$vars" ];then
   eval "$vars"
fi

set -xe
git clone "${ciab_repo_url:-https://github.com/osism/cloud-in-a-box}" /opt/cloud-in-a-box
git -C /opt/cloud-in-a-box checkout "${ciab_branch:-main}"
/opt/cloud-in-a-box/bootstrap.sh sandbox
/opt/cloud-in-a-box/deploy.sh sandbox
