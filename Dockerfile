FROM debian:9.6 as builder

ARG HELM_CLIENT_SOURCE="https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-rc.4-linux-amd64.tar.gz"
ARG JFROG_CLI_SOURCE="https://bintray.com/jfrog/jfrog-cli-go/download_file?file_path=1.22.0/jfrog-cli-linux-amd64/jfrog"

ENV WORKDIR=~/download
WORKDIR $WORKDIR

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    curl -SsL -o helm-cli.tar.gz ${HELM_CLIENT_SOURCE} && \
    tar xzf helm-cli.tar.gz && \
    mv linux-amd64 helm-cli && \
    curl -SsL -o jfrog ${JFROG_CLI_SOURCE}
    
FROM debian:9.6

RUN apt-get update &&  \
    apt-get install -y ca-certificates

COPY --from=builder ~/download/helm-cli/helm /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm

COPY --from=builder ~/download/jfrog /usr/local/bin/jfrog
RUN chmod +x /usr/local/bin/jfrog
