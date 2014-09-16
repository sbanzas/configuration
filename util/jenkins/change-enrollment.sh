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

manage="/edx/bin/python.edxapp /edx/bin/manage.py lms change_enrollment --settings aws"

if [ $"noop" ]; then
  $ansible "$manage --noop --course $course --user $name --to $to --from $from"
else
  $ansible "$manage --course $course --user $name --to $to --from $from"
fi
