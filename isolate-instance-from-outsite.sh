#!/bin/sh

#Create a security group to isolate your instance, note the difference between EC2-Classic and EC2-VPC, take note of Group-ID
aws ec2 create-security-group --group-name isolation-sg --description “Security group to isolate EC2-Classic instances"
aws ec2 create-security-group --group-name isolation-sg --description “Security group to isolate a EC2-VPC instance" --vpc-id vpc-1a2b3c4d 
# where vpc-1a2b3c4d is the VPC ID that the instance is member of

#Set a rule to allow SSH access from your public IP only, but first we have to know our public IP:
dig +short myip.opendns.com @resolver1.opendns.com
aws ec2 authorize-security-group-ingress --group-name isolation-sg --protocol tcp --port 22 --cidr YOUR.IP.ADDRESS.HERE/32
aws ec2 authorize-security-group-ingress --group-id sg-BLOCK-ID --protocol tcp --port 22 --cidr YOUR.IP.ADDRESS.HERE/32 
# note the difference between both commands in group-name and group-id, sg-BLOCK-ID is the ID of your isolation-sg

#In EC2-Classic Security Groups don’t support outbound rules, I provide a script below to totally block outbound traffic within the instance. However, for EC2-VPC Security Groups, outbound rules can be set with these commands:
aws ec2 revoke-security-group-egress --group-id sg-BLOCK-ID --protocol '-1' --port all --cidr '0.0.0.0/0’ 
# removed rule that allows all outbound traffic
aws ec2 authorize-security-group-egress --group-id sg-BLOCK-ID --protocol 'tcp' --port 80 --cidr '0.0.0.0/0’ 
# place a port or IP if you want to enable some other outbound traffic otherwise do not execute this command.

#Apply that Security Group to the compromised instance:
aws ec2 modify-instance-attribute --instance-id i-INSTANCE-ID --groups sg-BLOCK-ID 
# where sg-BLOCK-ID is the ID of your isolation-sg
