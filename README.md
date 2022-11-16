docker-apache2-perl-cgi
=======================

Dockerfile for Apache2 HTTP server with Perl CGI

[![CI to Docker Hub](https://github.com/dceoy/docker-apache2-perl-cgi/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/dceoy/docker-apache2-perl-cgi/actions/workflows/docker-publish.yml)

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/apache2-perl-cgi/).

```sh
$ docker image pull dceoy/apache2-perl-cgi
```

Usage
-----

Run Apache2

```sh
$ docker container run --rm -p 80:80 -v ${PWD}:/usr/lib/cgi-bin \
    dceoy/apache2-perl-cgi -D FOREGROUND
```

Run Apache2 with docker-compose

```sh
$ docker-compose -f /path/to/docker-apache2-perl-cgi/docker-compose.yml up
```
