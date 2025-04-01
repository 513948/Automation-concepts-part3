#!/bin/bash

DB_USERNAME="TestTest"
DB_PASSWORD="TestTest"
# The AMI's used are based on US-east-1
REGION="us-east-1"

# Deploy Stack 1: AZStack
echo "Creating stack: AZStack"
aws cloudformation create-stack --stack-name "AZStack" --template-body file://az.yaml --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "AZStack" --region "$REGION"
echo "AZStack deployment is complete!"

# Deploy Stack 2: DatabaseStack
echo "Creating stack: DatabaseStack"
aws cloudformation create-stack --stack-name "DatabaseStack" \
  --template-body file://rds.yml \
  --parameters ParameterKey=DBUsername,ParameterValue="$DB_USERNAME" \
               ParameterKey=DBPassword,ParameterValue="$DB_PASSWORD" \
  --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "DatabaseStack" --region "$REGION"
echo "DatabaseStack deployment is complete!"

# Deploy Stack 3: LBStack
echo "Creating stack: LBStack"
aws cloudformation create-stack --stack-name "LBStack" --template-body file://lb.yml --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "LBStack" --region "$REGION"
echo "LBStack deployment is complete!"

# Deploy Stack 4: EFSStack
echo "Creating stack: EFSStack"
aws cloudformation create-stack --stack-name "EFSStack" --template-body file://efs.yml --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "EFSStack" --region "$REGION"
echo "EFSStack deployment is complete!"

# Deploy Stack 5: ASGStack
echo "Creating stack: ASGStack"
aws cloudformation create-stack --stack-name "ASGStack" --template-body file://asg.yaml --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "ASGStack" --region "$REGION"
echo "ASGStack deployment is complete!"

# Deploy Stack 6: ELKStack
echo "Creating stack: ELKStack"
aws cloudformation create-stack --stack-name "ELKStack" --template-body file://elk.yaml --region "$REGION"
aws cloudformation wait stack-create-complete --stack-name "ELKStack" --region "$REGION"
echo "ELKStack deployment is complete!"

# Deploy Stack 7: S3 export stack
echo "Creating stack: EXPStack"
aws cloudformation create-stack --stack-name "EXPStack" --template-body file://exp.yaml --region "$REGION" --capabilities CAPABILITY_NAMED_IAM
aws cloudformation wait stack-create-complete --stack-name "EXPStack" --region "$REGION"
echo "EXPStack deployment is complete!"

echo "All stacks have been deployed!"
