FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN set -e \
      && ln -sf bash /bin/sh

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apache2 apt-transport-https ca-certificates curl libapache2-mod-perl2 \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && echo >> /etc/apache2/apache2.conf \
      && echo 'ServerName localhost' >> /etc/apache2/apache2.conf \
      && echo 'TransferLog /dev/stdout' >> /etc/apache2/apache2.conf \
      # && sed -ie 's/^\(ErrorLog \).*$/\1\/dev\/stderr/' /etc/apache2/apache2.conf \
      && sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        -e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*User)\s+daemon\s*$!\1 www-data!g' \
        -e 's!^(\s*Group)\s+daemon\s*$!\1 www-data!g' \
        /etc/apache2/apache2.conf \
        /etc/apache2/sites-available/000-default.conf \
        /etc/apache2/sites-available/default-ssl.conf \
        /etc/apache2/sites-enabled/000-default.conf \
        /etc/apache2/conf-available/other-vhosts-access-log.conf \
        /etc/apache2/conf-enabled/other-vhosts-access-log.conf

RUN set -e \
      && a2enmod cgid 

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

STOPSIGNAL SIGWINCH

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apachectl"]
CMD ["-D", "FOREGROUND"]
