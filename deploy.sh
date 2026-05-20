#!/bin/sh

cd $m_TERRAFORM_ROOT_MODULE

terraform init
terraform apply -auto-approve

retries=0
PUBLIC_DNS="$(terraform output -raw public_ip)"
INSTANCE_ID="$(terraform output -raw instance_id)"

echo "Waiting for the instance to pass status checks ..."
while [ "$(aws ec2 describe-instance-status --region $AWS_REGION --instance-ids $INSTANCE_ID --query 'InstanceStatuses[*].{InstanceStatus:InstanceStatus.Status,SystemStatus:SystemStatus.Status}' --output text | awk '{print $1,$2}')" != "ok ok" ]; do
    retries=$((retries + 1))
    if [ "$retries" -gt "60" ]; then
        python3 -c 'print("  ✖️ Instance is not ready")' >&2
        echo "Exiting..."
        exit 1
    fi
    sleep 10
    echo "Waiting for the instance to pass status checks ..."
done

python3 -c 'print("  ✔️ Instance is ready")'

python3 -c 'print("  🚀 Deploy application")'
cd $m_ANSIBLE_CONFIG_DIR
ansible-playbook main.yaml -i $m_ANSIBLE_INVENTORY_FILE --vault-password-file .passwd

python3 -c 'print("  🎉 The application has been deployed 🎉")'
echo $PUBLIC_DNS