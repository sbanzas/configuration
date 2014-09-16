#!/bin/bash

cd configuration
pip install -r requirements.txt
env

if [[ "$cluster" = "prod" ]]; then
  ansible="ansible first_in_tag_Name_prod-edx-worker -i playbooks/ec2.py -u ubuntu -s -U www-data -a"
elif [[ "$cluster" = "edge" ]]; then
  ansible="ansible first_in_tag_Name_prod-edge-worker -i playbooks/ec2.py -u ubuntu -s -U www-data -a"
fi

manage="/edx/bin/python.edxapp /edx/bin/manage.edxapp lms --settings aws"

if [ "$report" = "true" ]; then
  $ansible "$manage gen_cert_report -c $course_id"
elif [ "$regenerate" = "true" ] ; then
    $ansible "$manage regenerate_user -c $course_id -u $username"
  else
    $ansible "$manage ungenerated_certs -c $course_id"
    $ansible "$manage gen_cert_report -c $course_id"
  if [ "$force_certificate_state" ]; then
    $ansible "$manage ungenerated_certs -c $course_id $force_certificate_state"
    $ansible "$manage gen_cert_report -c $course_id"
  fi
fi
