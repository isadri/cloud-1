#!/bin/sh

cd $m_TERRAFORM_ROOT_MODULE

terraform init
terraform apply -auto-approve

retries=0
PUBLIC_DNS="$(terraform output -raw public_dns)"
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

python3 -c 'print("  🚀 Deploy application")'
cd $m_ANSIBLE_CONFIG_DIR
ansible-playbook main.yaml -i $m_ANSIBLE_INVENTORY_FILE --vault-password-file .passwd

python3 -c 'print("  🎉 The application has been deployed 🎉")'
echo $PUBLIC_DNS