FROM ubuntu:18.04
LABEL maintainer="Anton Kozik"

ENV LAST_UPDATE=2019-03-14
ARG AWSCLI_VERSION=1.16.124

ENV PYTHONIOENCODING=UTF-8

RUN apt-get update -qq

RUN apt-get install -y \
    tzdata \
    locales

# Set the timezone
RUN echo "Europe/Warsaw" | tee /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Set the locale for UTF-8 support
RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install \
    python3-pip && \
    pip3 install awscli==${AWSCLI_VERSION} && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash aws
WORKDIR /home/aws
USER aws

CMD ["/bin/bash", "-c"]
