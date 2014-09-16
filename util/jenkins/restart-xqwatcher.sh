#!/bin/bash

cd configuration
pip install -r requirements.txt
env

command="/edx/app/xqwatcher/venvs/supervisor/bin/supervisorctl -c /edx/app/xqwatcher/supervisor/supervisord.conf restart xqwatcher"

if [[ "$cluster" = "prod" ]]; then
  ansible tag_Name_prod-edx-xqwatcher -i playbooks/ec2.py -u ubuntu -s -a "$command"
elif [[ "$cluster" =  "stage" ]]; then
  ansible tag_Name_stage-edx-xqwatcher -i playbooks/ec2.py -u ubuntu -s -a "$command"
fi
