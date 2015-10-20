#!/bin/bash 
#creating instances with parameters
declare -a instance_id 
mapfile -t instance_id  < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --security-group-ids $5 --subnet-id $6 --associate-public-ip-address --iam-instance-profile Name=$7 --user-data file:///home/controller/Documents/Environment-Setup/install-env.sh --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")
echo ${instance_id[@]} 
aws ec2 wait instance-running --instance-ids ${instance_id[@]}