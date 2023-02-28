# Ansible_EMC_ECS
A collection of ansible playbooks for Dell EMC ECS

The playbooks demonstrate the interoperability between Ansible and Dell EMC ECS using native modules.
1. The folder ECSmgmt has example playbooks using the ansible "URI" module with the ECS management API
2. The folder ECSs3 has an example playbook using the ansible "AWS_S3" module with ECS S3 Data API

Requirements - Install below packages with Python package manager

pip install jmespath boto3
