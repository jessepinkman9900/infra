# AWS EC2
## Pre-req Tools
- Terraform v1.6.2
- [Infracost v0.10.29](https://github.com/infracost/infracost)

## Terraform
- Todo: setup remote backend to store tf state
```shell
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
terraform validate
terraform apply
```
```shell
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
terraform destroy
```

## Cost Estimation
```shell
# first time: infracost auth login
infracost breakdown --path=./terraform --format=json --out-file=infracost-usage.json
infracost diff --path=./terraform --compare-to infracost-usage.json
```

## IAM
- AmazonEC2FullAccess
