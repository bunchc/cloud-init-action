#!/bin/sh -l

starttime=$(date)
echo "::set-output name=starttime::$starttime"
/usr/bin/ansible-playbook -vvv /playbooks/vib_build.yml
endtime=$(date)
echo "::set-output name=endtime::$endtime"