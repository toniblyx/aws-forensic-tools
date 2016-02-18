#!/bin/sh

# My system IP/set ip address of server
OFFICE_IP=“YOUR.PUBLIC.IP.ADDR"
# Flushing all rules
iptables -F
iptables -X
# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# Allow incoming ssh only
iptables -A INPUT -p tcp -s $OFFICE_IP  --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d $OFFICE_IP --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
# make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

# for FirewallD to test
# firewall-cmd --add-rich-rule="rule family="ipv4" source address="$OFFICE_IP" service name="ssh" accept"
# firewall-cmd --zone=internal --add-service=ssh
# firewall-cmd --zone=internal --add-source=192.168.56.105/32
# firewall-cmd --zone=internal --add-source=192.168.56.120/32
# firewall-cmd --zone=public --remove-service=ssh
