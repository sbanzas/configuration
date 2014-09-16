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

manage="/edx/bin/python.edxapp /edx/bin/manage.edxapp lms --settings aws"

echo "$username" > /tmp/username.txt

if [ "$addremove" = "add" ]; then
  for x in $(cat /tmp/username.txt); do
    echo "Adding $x"
    $ansible "$manage --add $x -c $course_id"
  done
elif [ "$addremove" = "remove" ]; then
  for x in $(cat /tmp/username.txt); do
    echo "Removing $x"
    $ansible "$manage --del $x -c $course_id"
  done
fi

rm /tmp/username.txt
