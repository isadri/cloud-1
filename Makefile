provision-infra:
	docker compose run -it --rm --workdir /app/srcs/infra/live/stage/app cloud-1 terraform apply

destroy-infra:
	docker compose run -it --rm --workdir /app/srcs/infra/live/stage/app cloud-1 terraform destroy

tf-validate:
	docker compose run --rm --workdir /app/srcs/infra/live/stage/app cloud-1 terraform validate

tf-fmt:
	docker compose run --rm --workdir /app/srcs/infra cloud-1 find . -name "*.tf" -exec terraform fmt {} \;