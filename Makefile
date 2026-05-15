provision-infra:
	docker compose run -it --rm --workdir /app/srcs/provision/live/stage/app cloud-1 terraform apply

destroy-infra:
	docker compose run -it --rm --workdir /app/srcs/provision/live/stage/app cloud-1 terraform destroy