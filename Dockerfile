FROM debian:13 AS builder

# Install Terraform
RUN apt-get update && apt-get install -y gnupg wget lsb-release && wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

FROM python:3.14-alpine3.22

WORKDIR /app

COPY requirements.txt /app
COPY --from=builder /usr/bin/terraform /usr/bin/terraform

# Install dependencies
RUN pip install -r requirements.txt && apk add --no-cache aws-cli openssh

COPY ./deploy.sh /app

RUN chmod +x /app/deploy.sh

CMD [ "/app/deploy.sh" ]