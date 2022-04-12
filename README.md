# How-To Guide for Secure-Elasticsearch-AWS-EC2

It made by Terraform to provision Elasticsearch instance at AWS EC2.

## A. Prerequisites

1. download AWS Secret

2. Clone this ansible repo [https://github.com/ridwanbejo/ansible-secure-elasticsearch](https://github.com/ridwanbejo/ansible-secure-elasticsearch) because we need to bootstrap the Elasticsearch

3. Clone this repo to your directory

3. Change your current directory to the repo

4. generate key pairs for EC2 SSH access inside the cloned repo

```
ssh-keygen -f singapore-region-key-pair
chmod 400 singapore-region-key-pair.pem
```

## B. Single Node

1. plan the terraform

```
terraform plan -var-file=test.tfvars
```

2. apply the terraform

```
terraform apply -var-file=test.tfvars
```

3. Update Ansible inventory

```
nano /etc/ansible/hosts

ec2-13-213-77-223.ap-southeast-1.compute.amazonaws.com

```

4. Run the cloned ansible playbook to install the Elasticsearch

```
ansible-playbook -u ubuntu --private-key singapore-region-key-pair -e 'pub_key=singapore-region-key-pair.pub' elasticsearch-install.yml
```

5. Test the Elasticsearch deployment from your local machine

```
curl -XGET -u elastic:Test@12345 http://ec2-18-139-85-2.ap-southeast-1.compute.amazonaws.com:9200/?pretty
curl -XGET -u elastic:Test@12345 http://ec2-18-139-85-2.ap-southeast-1.compute.amazonaws.com:9200/_cluster/health?prettys
```

## C. Cluster Node (experimental)

1. Uncomment two commented resources inside `main.tf`

2. plan the terraform

```
terraform plan -var-file=test.tfvars
```

3. apply the terraform

```
terraform apply -var-file=test.tfvars
```

4. Update Ansible inventory

```
nano /etc/hosts

ec2-13-213-77-223.ap-southeast-1.compute.amazonaws.com
ec2-13-213-77-224.ap-southeast-1.compute.amazonaws.com
ec2-13-213-77-225.ap-southeast-1.compute.amazonaws.com

```

4. Run the cloned ansible playbook to install the Elasticsearch

```
ansible-playbook -u ubuntu --private-key singapore-region-key-pair -e 'pub_key=singapore-region-key-pair.pub' elasticsearch-cluster-install.yml
```

5. If the EC2 instances have a proper capacity, the Elasticsearch Cluster installation might work. But in this repo I still have misconfiguration for the SSL transport. The certificate should be only generated once from master and distributed it to data nodes. Not generate the certificate in each nodes because the cluster might not be able to talk each other.


# References

- https://aku.dev/create_aws_ec2_instance_with_terraform/
- https://aku.dev/terraform-vpc-introduction/
- https://medium.com/@aliatakan/terraform-create-a-vpc-subnets-and-more-6ef43f0bf4c1
- https://www.digitalocean.com/community/tutorials/how-to-use-ansible-with-terraform-for-configuration-management
- https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180
- https://www.thinkstack.co/blog/using-terraform-to-create-an-ec2-instance-with-cloudwatch-alarm-metrics
