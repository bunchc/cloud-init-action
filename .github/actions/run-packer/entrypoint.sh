#!/bin/sh -l

# Parameters
#
# $1 - verbosity '-vvv'
# $2 - playbook '/ansible/destroy.yml'
# $3 - inventory

starttime=$(date)
echo "::set-output name=starttime::$starttime"
/usr/bin/ansible-playbook --version

if [ -z "$3" ]; then # If no inventory file is passed, just run the playbook
  /usr/bin/ansible-playbook $1 $2
else # Otherwise pass the inventory
  /usr/bin/ansible-playbook -i $3 $1 $2
fi

if [ $? -eq 0 ]
then
  endtime=$(date)
  echo "::set-output name=endtime::$endtime"
else
  echo "Ansible failed"
  endtime=$(date)
  echo "::set-output name=endtime::$endtime"
  exit 1
fi