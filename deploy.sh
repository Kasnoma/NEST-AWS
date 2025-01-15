#! /bin/bash

echo "[>] Starting deployment to server"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo apt-get update

sudo ./aws/install --update

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID

aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

aws configure set default.region $AWS_DEFAULT_REGION

aws --version

aws ssm send-command --document-name "AWS-RunShellScript" --document-version "1" --targets '[{"Key":"InstanceIds","Values":["i-08482125e58fe0533"]}]' --parameters '{"workingDirectory":[""],"executionTimeout":["3600"],"commands":["sudo su ubuntu","cd /home/ubuntu/nest-app","aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 904233112587.dkr.ecr.us-east-1.amazonaws.com","docker image prune --all --filter \"until=24h\"", "source .env", "docker compose pull && docker compose up -d"]}' --timeout-seconds 1200 --max-concurrency "50" --max-errors "0" --region us-east-1
#aws ssm send-command --document-name "AWS-RunShellScript" --document-version "1" --targets '[{"Key":"InstanceIds","Values":["i-070ac9723d7243653"]}]' --parameters '{"workingDirectory":[""],"executionTimeout":["3600"],"commands":["sudo su ubuntu","cd /home/ubuntu/hrms","aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin   615012739486.dkr.ecr.eu-central-1.amazonaws.com","docker image prune --all --filter \"until=24h\"", "source .env", "docker compose pull && docker compose up -d"]}' --timeout-seconds 1200 --max-concurrency "50" --max-errors "0" --region eu-central-1

#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 904233112587.dkr.ecr.us-east-1.amazonaws.com
