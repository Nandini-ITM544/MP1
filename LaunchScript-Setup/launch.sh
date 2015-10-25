#!/bin/bash 
#creating instances with parameters
declare -a instance_id 
mapfile -t instance_id  < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --security-group-ids $5 --subnet-id $6 --associate-public-ip-address --iam-instance-profile Name=$7 --user-data file:///home/controller/Documents/Environment-Setup/install-env.sh --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")
echo ${instance_id[@]} 
aws ec2 wait instance-running --instance-ids ${instance_id[@]}
aws elb create-load-balancer --load-balancer-name Project1 --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --security-groups sg-9f5edcfb --subnets subnet-00d78265
aws elb register-instances-with-load-balancer --load-balancer-name Project1 --instances ${instance_id[@]}
aws elb configure-health-check --load-balancer-name Project1 --health-check Target=HTTP:80/index.html,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3
aws autoscaling create-launch-configuration --launch-configuration-name Project1-launch-config --image-id ami-5189a661 --key-name A20307539Nandy --security-groups sg-9f5edcfb --instance-type t2.micro --user-data /home/controller/Documents/Environment-Setup/install-env.sh --iam-instance-profile phpdeveloperRole
aws autoscaling create-auto-scaling-group --auto-scaling-group-name Project1-extended-auto-scaling-group-2 --launch-configuration-name Project1-launch-config --load-balancer-names Project1 --health-check-type ELB --min-size 3 --max-size 6 --desired-capacity 3 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier subnet-00d78265	
aws rds create-db-instance --db-name MP1db --db-instance-identifier MP1db --db-instance-class db.t2.micro --engine MySql --allocated-storage 20 --master-username nandini90 --master-user-password nandini90
aws rds create-db-instance-read-replica --db-instance-identifier MP1readonly --source-db-instance-identifier MP1db --db-instance-class db.t2.micro 
