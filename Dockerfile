FROM alpine:latest

ENV TERRAFORM_VERSION 1.2.1
ENV RANCHER_VERSION v2.6.5
ARG PULUMI_VERSION=latest
ARG HELM_VERSION=3.9.0

#add curl, wget, ssh-client, ansible, etc
RUN apk --update --no-cache add \
    bash \
    ca-certificates \
    git \
    openssl \
    tzdata \
    wget \
    openssh-client \
    curl \
    ansible \
    py-pip \
    libc6-compat \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo \
    make \
    libc6-compat

# Install aws-cli
RUN pip install awscli

# Install azure-cli
RUN pip install azure-cli

# Install google-cli (Google cloud sdk)
RUN curl -sSL https://sdk.cloud.google.com | bash
   
#download and install rancher cli
RUN wget https://github.com/rancher/cli/releases/download/${RANCHER_VERSION}/rancher-linux-amd64-${RANCHER_VERSION}.tar.gz && \
    tar -xzvf rancher-linux-amd64-${RANCHER_VERSION}.tar.gz && \
    rm -f rancher-linux-amd64-${RANCHER_VERSION}.tar.gz && \
    chmod +x rancher-${RANCHER_VERSION}/rancher && \
    cp rancher-${RANCHER_VERSION}/rancher /bin/rancher && \
    rm -rf rancher-${RANCHER_VERSION}

#download and install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /bin/kubectl && \
    mkdir ~/.kube

#download and install terraform
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    cd /

#download and install pulumi
ENV PATH=$PATH:/root/.pulumi/bin

RUN apk update && \
    apk add --no-cache curl libc6-compat && \
    if [ "$PULUMI_VERSION" = "latest" ]; then \
      curl -fsSL https://get.pulumi.com/ | sh; \
    else \
      curl -fsSL https://get.pulumi.com/ | sh -s -- --version $(echo $PULUMI_VERSION | cut -c 2-); \
    fi

#download and install helm
ENV BASE_URL="https://get.helm.sh"

RUN case `uname -m` in \
        x86_64) ARCH=amd64; ;; \
        armv7l) ARCH=arm; ;; \
        aarch64) ARCH=arm64; ;; \
        ppc64le) ARCH=ppc64le; ;; \
        s390x) ARCH=s390x; ;; \
        *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    wget ${BASE_URL}/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz -O - | tar -xz && \
    mv linux-${ARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${ARCH}

RUN chmod +x /usr/bin/helm