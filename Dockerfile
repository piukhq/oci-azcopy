FROM docker.io/debian:12 as fetch
RUN apt-get update && apt-get -y install curl
WORKDIR /tmp
RUN if uname -m | grep -q "x86_64"; then \
        curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy.tgz; \
        curl -L https://github.com/linkerd/linkerd-await/releases/download/release%2Fv0.2.7/linkerd-await-v0.2.7-amd64 -o linkerd-await; \
    else \
        curl -L https://aka.ms/downloadazcopy-v10-linux-arm64 -o azcopy.tgz; \
        curl -L https://github.com/linkerd/linkerd-await/releases/download/release%2Fv0.2.7/linkerd-await-v0.2.7-arm64 -o linkerd-await; \
    fi
RUN tar xzvf azcopy.tgz --strip-components=1 --no-same-owner
RUN chmod +x azcopy
RUN chmod +x linkerd-await
RUN mv azcopy linkerd-await /usr/local/bin

FROM docker.io/debian:12-slim
COPY --from=fetch /etc/ssl /etc/ssl
COPY --from=fetch /usr/local/bin/ /usr/local/bin/
