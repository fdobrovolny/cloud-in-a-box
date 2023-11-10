#!/bin/bash

vars="$(tr ' ' '\n' < /proc/cmdline |grep -P '^ciab_.+=.+')"
if [ -n "$vars" ];then
   eval "$vars"
fi

set -xe
git clone "${ciab_repo_url:-https://github.com/osism/cloud-in-a-box}" /opt/cloud-in-a-box
git checkout -C /opt/cloud-in-a-box "${ciab_branch:-main}"
/opt/cloud-in-a-box/bootstrap.sh sandbox
/opt/cloud-in-a-box/deploy.sh sandbox
