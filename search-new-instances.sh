#!/bin/bash

#date format YYYY-MM-DD
DATE_SINCE=2016-02-01

# list of all available regions by Feb 17th 2016
REGIONS="us-east-1 us-west-2 us-west-1 eu-west-1 eu-central-1 ap-southeast-1 ap-northeast-1 ap-southeast-2 ap-northeast-2 sa-east-1"

for i in $REGIONS;
do
echo "####### Instances launched since $DATE_SINCE in $i #######"
aws ec2 describe-instances --region $i --query "Reservations[].Instances[?LaunchTime>=\`$DATE_SINCE\`][].{id: InstanceId, type: InstanceType, launched: LaunchTime}";
done

# get new instance console output log
# aws ec2 get-console-output --region eu-west-1 --instance-id i-ID
