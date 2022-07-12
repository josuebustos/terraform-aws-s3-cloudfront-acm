
## Information


This terraform module will create a private S3 bucket, CloudFront distribution with HTTPS endpoint and also origin access identity on our S3 bucket, SSL certificate with certificate manager, and finally it will create a record and it will point to our CloudFront distribution.


### Prerequisites

Before the deployment of this terraform module, make sure your hosted zone exists in Route 53 and move your domain to Route53 by changing NS records on your DNS provider.


### Installation

Change these two variables in the **terraform.tfvars** file.

```

SiteTags = "Example" (Tag value of the resources.)

domainName = "example.com" (This domain name should exists in the Route53. This module point this domain to CloudFront distribution and it will create SSL certificate for this domain name.)

```

You can now run this module when you change the variables.

```
terraform init
terraform plan
terrafom apply --auto-approve

```
<br>

## Update static content via Invalidation

Uploading a file to S3 will automatically overwrite the existing file or files.

To upload one file use this command:

```bash
aws s3 --profile default cp /path/to/your/file/index.html  s3://awsdevcamp.com/
```

To upload multiple files use this commands:
```bash
aws s3 --profile default --recursive cp /path/to/your/directory/  s3://bucket-name/
```

## Invalidate file/s 

To update the content in cloudfront you must invalidate it. Use the following command to do that.

To update one file use the aws invalidation command:

```bash
aws cloudfront --profile default create-invalidation --distribution-id <Invalidation-ID> --paths "/index.html"
```

To update/invalidate all files in a directory use this command:
```bash
aws cloudfront create-invalidation --distribution-id <Invalidation-ID> --paths "/*"
```

<br>

## Create a CloudFront Distribution for a Subdomain.

