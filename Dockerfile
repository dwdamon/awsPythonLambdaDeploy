FROM ubuntu:jammy

# Set the locale
RUN apt-get update
RUN apt upgrade -y

RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN DEBIAN_FRONTEND="noninteractive"
RUN ln -fs /usr/share/zoneinfo/America/Detroit /etc/localtime
RUN apt install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt install -y git curl wget

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -qy

RUN apt install -y nodejs \
                   build-essential \
                   awscli

RUN npm install -g serverless@3.20.0 \
                   serverless-domain-manager \
                   serverless-python-requirements \
                   serverless-plugin-split-stacks \
                   serverless-iam-roles-per-function \
                   serverless-scriptable-plugin \
                   serverless-prune-plugin \
                   serverless-api-compression \
                   serverless-plugin-scripts

#install python 3.9
RUN apt install -y build-essential \
                   checkinstall \
                   libreadline-dev \
                   libncursesw5-dev \
                   libssl-dev \
                   libsqlite3-dev \
                   tk-dev \
                   libgdbm-dev \
                   libc6-dev \
                   libbz2-dev \
                   libffi-dev \
                   zlib1g-dev

RUN cd /opt
RUN wget https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz
RUN tar xzf Python-3.9.13.tgz
RUN cd Python-3.9.13 && bash ./configure --enable-optimizations && make altinstall
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.9 0
RUN apt install -y python3-pip
RUN rm /usr/bin/lsb_release
RUN python3.9 -m pip install --upgrade pip

RUN useradd -r -d /home/deploy -s /bin/bash -g root -G sudo -u 1000 deploy
USER deploy
WORKDIR /home/deploy

CMD ["/usr/bin/bash"]
