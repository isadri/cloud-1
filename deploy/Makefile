PLAYBOOK_FILE := test.yaml

test-aws:
	ansible-playbook $(PLAYBOOK_FILE) -i inventories/prod/hosts.aws_ec2.yaml --vault-password-file .passwd