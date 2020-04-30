FROM ubuntu:xenial as builder

ENV DEBIAN_FRONTEND noninteractive
ARG MONO_VERSION=5.20
ARG MONO_URL=stable-xenial/snapshots/$MONO_VERSION

RUN apt-get update && apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get -y install yarn && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list >  /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg  /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y unzip git make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
ARG BUILD_NUMBER="0.16.999"

COPY . /build
RUN dotnet publish src/Jackett.Server/Jackett.Server.csproj --configuration Release --runtime linux-x64 --self-contained --framework netcoreapp3.1 --output _artifacts/server /p:AssemblyVersion=${BUILD_NUMBER} /p:FileVersion=${BUILD_NUMBER} /p:InformationalVersion=${BUILD_NUMBER} /p:Version=${BUILD_NUMBER}

FROM lsiobase/ubuntu:focal
LABEL maintainer="platbr"

ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_DATA_HOME="/config" \
XDG_CONFIG_HOME="/config"

RUN mkdir -p /app/Jackett
COPY --from=builder /build/_artifacts/server /app/Jackett
RUN apt-get update && \
    apt-get install -y libicu66 libssl1.0 wget  && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R root:root /app/Jackett

# add local files
COPY platbr/docker-root/ /

# ports and volumes
VOLUME /config
EXPOSE 9117
