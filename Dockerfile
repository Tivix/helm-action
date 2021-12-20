FROM alpine:3.14

ENV PYTHONUNBUFFERED=1

ENV helm_version=v3.2.1
ENV helm_checksum=018f9908cb950701a5d59e757653a790c66d8eda288625dbb185354ca6f41f6b

ENV kubectl_version=v1.18.2
ENV kubectl_checksum=6ea8261b503c6c63d616878837dc70b758d4a3aeb9996ade8e83b51aedac9698

ENV stern_version=1.11.0
ENV stern_checksum=e0b39dc26f3a0c7596b2408e4fb8da533352b76aaffdc18c7ad28c833c9eb7db

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
    curl -s -L https://github.com/wercker/stern/releases/download/${stern_version}/stern_linux_amd64 > /tmp/stern &&\
    sha256sum /tmp/stern | grep -q ${stern_checksum} &&\
    tar xzf /tmp/helm.tar.gz -C /tmp/ &&\
    chmod +x /tmp/kubectl /tmp/stern /tmp/linux-amd64/helm &&\
    mv /tmp/kubectl /tmp/stern /tmp/linux-amd64/helm /usr/local/bin/ &&\
    rm -rf /tmp/*

COPY scripts/* /usr/local/bin/

ENTRYPOINT ["helm-action"]
