FROM alpine:3.14

ENV PYTHONUNBUFFERED=1

ENV helm_version=v3.7.2
ENV helm_checksum=4ae30e48966aba5f807a4e140dad6736ee1a392940101e4d79ffb4ee86200a9e

ENV kubectl_version=v1.21.8
ENV kubectl_checksum=84eaef3da0b508666e58917ebe9a6b32dcc6367bddf6e4489b909451877e3e70

ENV stern_version=1.21.0
ENV stern_checksum=18bb5afa0426d1ca2e975bee2a04037378d99ffdda6e3383a575ad28d5c2d04d

RUN apk add --no-cache \
    curl \
    ca-certificates \
    python3 \
    py3-pip \
    jq &&\
    pip --no-cache-dir install \
    ruamel.yaml==0.16.10 \
    awscli==1.18.61 \
    sh==1.13.1

RUN curl -s https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl > /tmp/kubectl &&\
    sha256sum /tmp/kubectl | grep -q ${kubectl_checksum} &&\
    curl -s https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz > /tmp/helm.tar.gz &&\
    sha256sum /tmp/helm.tar.gz | grep -q ${helm_checksum} &&\
    curl -s -L https://github.com/stern/stern/releases/download/v${stern_version}/stern_${stern_version}_linux_amd64.tar.gz > /tmp/stern.tar.gz &&\
    sha256sum /tmp/stern.tar.gz | grep -q ${stern_checksum} &&\
    tar xzf /tmp/helm.tar.gz -C /tmp/ &&\
    tar xzf /tmp/stern.tar.gz -C /tmp/ &&\
    chmod +x /tmp/kubectl /tmp/stern /tmp/linux-amd64/helm &&\
    mv /tmp/kubectl /tmp/stern /tmp/linux-amd64/helm /usr/local/bin/ &&\
    rm -rf /tmp/*

COPY scripts/* /usr/local/bin/

ENTRYPOINT ["helm-action"]
