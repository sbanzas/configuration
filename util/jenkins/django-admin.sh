#!/bin/bash

cd configuration
pip install -r requirements.txt
env

if [[ "$cluster" = "prod" ]]; then
  ansible="ansible first_in_tag_Name_prod-edx-worker -i playbooks/ec2.py -u ubuntu -s -U www-data -a"
elif [[ "$cluster" = "stage" ]]; then
  ansible="ansible first_in_tag_Name_stage-edx-worker -i playbooks/ec2.py -u ubuntu -s -U www-data -a"
elif [[ "$cluster" = "edge" ]]; then
  ansible="ansible first_in_tag_Name_prod-edge-worker -i playbooks/ec2.py -u ubuntu -s -U www-data -a"
fi

manage="/edx/bin/python.edxapp ./manage.py  chdir=/edx/app/edxapp/edx-platform"

if [ "$service_variant" != "UNSET" ]; then
  manage="$manage $service_variant --settings aws"
fi

if [ "$help" = "true" ]; then
  manage="$manage help"
fi

$ansible "$manage $command $options --settings aws"
