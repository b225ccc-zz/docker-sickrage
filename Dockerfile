FROM ubuntu:14.04

MAINTAINER b225ccc@gmail.com

# install dependencies
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git supervisor && \
  apt-get install -y libxslt1-dev libxslt1.1 libxml2-dev \
    libxml2 libssl-dev libffi-dev python-pip python-dev libssl-dev && \
  rm -rf /var/lib/apt/lists/*

RUN \
  mkdir -p /var/log/supervisor

# build unrar
RUN \
  cd /tmp && \
  curl -o unrarsource.tar.gz http://rarlab.com/rar/unrarsrc-5.2.7.tar.gz && \
  tar -xvf /tmp/unrarsource.tar.gz && \
  cd unrar && \
  make -f makefile && \
  install -v -m755 unrar /usr/bin && \
  rm -rf /tmp/unrar*

# create sickrage user
# user will default to the 'nogroup' group
RUN \
  adduser --system --uid 65001 --no-create-home sickrage

# add custom files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN \
  git clone -q https://github.com/SickRage/SickRage.git /opt/sickrage && \
  chown sickrage:nogroup -R /opt/sickrage

# volumes
VOLUME /config /downloads /tv

# ports
EXPOSE 8081

CMD ["/usr/bin/supervisord"]
