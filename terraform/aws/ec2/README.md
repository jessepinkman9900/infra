# AWS EC2
## Pre-req Tools
- Terraform v1.6.2
- [Infracost v0.10.29](https://github.com/infracost/infracost)

## Terraform
- Todo: setup remote backend to store tf state
```shell
# update: terraform.tfvars
cd terraform
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
terraform validate
terraform apply
```
```shell
cd terraform
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
terraform destroy
```

## [Cost Estimation](https://www.infracost.io/docs/)
```shell
# first time: infracost auth login
# cost of total deployment
infracost breakdown --path=./terraform --format=json --out-file=infracost-usage.json
```
```shell
# change in cost due to change in resources
infracost diff --path=./terraform --compare-to infracost-usage.json
```

## IAM
- AmazonEC2FullAccess

## [IAM permissions for S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3#s3-bucket-permissions)
- s3:ListBucket
- s3:GetObject
- s3:PutObject
- s3: DeleteObject

## [Terratest](https://terratest.gruntwork.io/docs/)
```shell
cd test
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
go test -v
```

## [Visualisation](https://github.com/im2nguyen/rover)
```shell
cd terraform
# set IAM creds in .env
docker run --rm -it -p 9000:9000 -v "$(pwd):/src" --env-file ./.env im2nguyen/rover:v0.3.3
# see vis on http://localhost:9000
```
