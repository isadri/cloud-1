#!/bin/sh

cd /app/srcs/provision/live/stage/app

terraform init
terraform apply -auto-approve

retries=0
INSTANCE_ID="$(terraform output -raw instance_id)"

while [ "$(aws ec2 describe-instance-status --region $AWS_REGION --instance-ids $INSTANCE_ID --query 'InstanceStatuses[*].{InstanceStatus:InstanceStatus.Status,SystemStatus:SystemStatus.Status}' --output text | awk '{print $1,$2}')" != "ok ok" ]; do
    echo "Waiting for the instance to pass status checks ..."
    sleep 5
    if [ "$count" -gt "1200" ]; then
        echo "Instance is not healthy" >&2
        exit 1
    fi
done

echo "Instance is ready!"

echo "Deploy application"
cd /app/srcs/deploy
ansible-playbook main.yaml -i inventories/stage/hosts.aws_ec2.yaml --vault-password-file .passwd

echo "Visit the page and have fun!"
echo "$(terraform output -raw public_dns)"