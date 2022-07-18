FROM centos@sha256:8faead07bd1d5fdd17414a1759eae004da5daa9575a846f4730f44dec0f47843

USER root


RUN yum install -y tar unzip && \
    yum update -y && \
    yum clean all

ARG UID=5454
ARG GID=6565

RUN groupadd -g $GID app-group && \
    useradd -g app-group -u $UID app-user && \
    mkdir /workdir

WORKDIR /workdir
COPY target/*.jar app.jar

USER app-user
ENV HOME=/home/app-user

WORKDIR /home/app-user

RUN mkdir -f .bin && \
    cd .bin && \
    curl -L https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jre_x64_linux_hotspot_17.0.3_7.tar.gz | tar -xz

ENV PATH="${HOME}/.bin/jdk-17.0.3+7-jre/bin:${PATH}"

WORKDIR /workdir

ENTRYPOINT ["bash", "-c", "java -ea -jar app.jar"]
