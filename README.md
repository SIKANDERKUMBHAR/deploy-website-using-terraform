
```markdown
# Deploy Static Website Using One Terraform Command

This project is to deploy a static website in AWS EC2 instance and S3 bucket using Terraform.

## Files

### main.tf
This file contains the Terraform configuration for:
- Setting required providers.
- Configuring the AWS provider.
- Creating an IAM role and policy for EC2.
- Attaching the policy to the IAM role.
- Creating an IAM instance profile.
- Launching an EC2 instance with necessary configurations and user data.
- Defining the security group to be used.

### upload_file_to_s3.tf
This file contains the Terraform configuration for:
- Uploading files from `folder1` to S3.
- Uploading files from `folder2` to S3.
- Uploading an `index.html` file to S3.

## Terraform Commands

1. Initialize the Terraform configuration:
   ```sh
   terraform init
   ```

2. Apply the Terraform configuration:
   ```sh
   terraform apply
   ```
   Review the plan and confirm the apply with `yes`.

This will deploy the static website in AWS EC2 instance and upload necessary files to the S3 bucket.
