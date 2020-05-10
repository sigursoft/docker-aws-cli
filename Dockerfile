FROM ubuntu:18.04
LABEL maintainer="Anton Kozik"

ENV LAST_UPDATE=2020-05-10
ENV AWSCLI_VERSION=1.18.46

#####################################################################################
# Current version is aws-cli/1.18.46 Python/3.6.7
#####################################################################################

RUN apt-get update -q

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

# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

# man and less are needed to view 'aws <command> help'
# ssh allows us to log in to new instances
# nano is useful to write shell scripts
# python* is needed to install aws cli using pip install

RUN apt-get install -y \
    jq \
    less \
    man \
    ssh \
    nano \
    python3-pip \
    zip

RUN pip3 install virtualenv

RUN adduser --disabled-login --gecos '' aws
WORKDIR /home/aws

USER aws

RUN \
    mkdir aws && \
    python3 -m virtualenv aws/env && \
    ./aws/env/bin/pip install awscli==${AWSCLI_VERSION} && \
    echo 'source $HOME/aws/env/bin/activate' >> .bashrc && \
    echo 'complete -C aws_completer aws' >> .bashrc

ENTRYPOINT ["/bin/bash"]
