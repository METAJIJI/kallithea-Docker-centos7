# docker build -t kallithea-gevent .
FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum erase -y selinux-policy NetworkManager firewalld postfix && yum autoremove -y
RUN yum install -y epel-release; yum clean all
RUN yum install -y procps-ng bash-completion openssl; yum clean all
RUN yum install -y git python-virtualenv supervisor rabbitmq-server nginx gcc; yum clean all
RUN easy_install supervisor-stdout

RUN mkdir /srv/kallithea
RUN mkdir /srv/kallithea/repo_data
RUN virtualenv /srv/kallithea/venv

RUN /srv/kallithea/venv/bin/pip install --upgrade setuptools
RUN /srv/kallithea/venv/bin/pip install kallithea funcsigs
RUN /srv/kallithea/venv/bin/pip install gunicorn gevent

# Create the kallithea user and group
RUN groupadd -r kallithea -g 1001 && useradd -u 1001 -r -g kallithea -d /srv/kallithea -s /sbin/nologin -c "kallithea user" kallithea

ADD ./deploy/supervisord.conf /etc/supervisord.conf
ADD ./deploy/nginx.conf /etc/nginx/nginx.conf
ADD ./deploy/my.ini /srv/kallithea/my.ini

# Create empty database
RUN (cd /srv/kallithea; yes 'y' | /srv/kallithea/venv/bin/paster setup-db my.ini --user=admin --password=admin --email=admin@example.ltd --repos=/srv/kallithea/repo_data)

RUN chown -R kallithea:kallithea /srv/kallithea

EXPOSE 5000 80

CMD supervisord -c /etc/supervisord.conf -n
