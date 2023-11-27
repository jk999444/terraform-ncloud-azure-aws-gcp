#!/bin/bash

scp -i /mnt/c/Terraform_ncloud_test/ncp20231116.pem root@223.130.160.251:/var/log/logs.log /mnt/c/Terraform_ncloud_test/logs.log

cat /mnt/c/Terraform_ncloud_test/logs.log
