ARG  VERSION=3.13.6
FROM alpine:${VERSION}

#Notes: Uses alpine to build a container as an executable running terraform version 1.0.10

LABEL maintainer            = "Terraformers <https://github.com/ycit-team-terraformers>"
LABEL authors               = "Terraformers YCIT021"
LABEL site                  = "https://github.com/ycit-team-terraformers"
LABEL description           = "Container able to run terraform. Container to be used as an executable."
LABEL note.a                = "ENTRYPOINT is terraform."
LABEL note.b                = "init is default parameter specified in the form CMD [param] If the user specifies arguments to docker run command, then new arguments will override the default specified in CMD."

LABEL change.new-a           ="Added volume 'terraformfiles' to use as working folder, terraform scripts expected here."
LABEL change.new-b           ="Added ENV TF_CLI_CONFIG_FILE to point to a file having the token to connect to Terraform Cloud, file should be named .terraformrc under the volume created terraformfiles."
LABEL change.new-c           ="Added symbolink link /root/.terraform.d to volume /terraformfiles. when using terraform login command the token files will be placed in the mounted volume."
LABEL change.new-d           ="Downloads terraform from https://releases.hashicorp.com/terraform/1.0.10/terraform_1.0.10_linux_amd64.zip."

ENV TERRAFORM_VERSION=1.0.10

RUN apk add --update --no-cache bash 

ENV TF_DEV=true
ENV TF_RELEASE=true
ENV TF_CLI_CONFIG_FILE=/terraformfiles/.terraformrc

ENV GOOGLE_APPLICATION_CREDENTIALS=/terraformfiles/gcp_auth.json

# Donwload terraform version 1.0.10
RUN wget https://releases.hashicorp.com/terraform/1.0.10/terraform_1.0.10_linux_amd64.zip
RUN unzip terraform_1.0.10_linux_amd64.zip && rm terraform_1.0.10_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

#Delete cache files
RUN rm -rf /var/cache/apk/*

VOLUME /terraformfiles

RUN mkdir -p /root/.terraform.d
RUN ln -sf /root/.terraform.d /terraformfiles

WORKDIR /terraformfiles

ENTRYPOINT ["terraform"]
CMD ["init"]
