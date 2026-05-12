PLAYBOOK_FILE := test.yaml

test-aws:
	ansible-playbook $(PLAYBOOK_FILE) -i inventories/prod/hosts.aws_ec2.yaml --extra-vars "ansible_user=ubuntu" --extra-vars "ansible_ssh_private_key_file=~/Downloads/learn.pem" --vault-password-file .passwd