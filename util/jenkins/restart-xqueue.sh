#!/bin/bash

cd configuration
pip install -r requirements.txt
env

command="/edx/bin/supervisorctl restart xqueue && /edx/bin/supervisorctl restart xqueue_consumer"

if [[ "$cluster" = "prod" ]]; then
  ansible tag_Name_prod-edx-commoncluster -i playbooks/ec2.py -u ubuntu -s -a "$command"
elif [[ "$cluster" = "stage" ]]; then
  ansible tag_Name_stage-edx-commoncluster -i playbooks/ec2.py -u ubuntu -s -a "$command"
fi
