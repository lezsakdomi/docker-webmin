FROM ubuntu:bionic

RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
		apt-transport-https ca-certificates software-properties-common gnupg \
		curl wget

ARG LC_ALL=hu_HU.UTF-8
RUN echo "\033[1mInstalling Webmin...\033[0m" \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
		locales \
	&& dpkg-reconfigure locales && locale-gen ${LC_ALL} && /usr/sbin/update-locale LANG=${LC_ALL} \
	&& curl http://www.webmin.com/jcameron-key.asc | apt-key add - \
	&& add-apt-repository "deb https://download.webmin.com/download/repository sarge contrib" \
	&& add-apt-repository "deb https://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" \
	&& apt-get update && apt-get install -y \
		webmin \
	&& apt-get clean
ENV LC_ALL ${LC_ALL}
EXPOSE 10000
CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log

RUN echo "\033[1mInstalling server softwares...\033[0m" \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
		apache2 \
		libapache2-mod-php \
		mysql-server \
		phpmyadmin \
		proftpd \
	&& DEBIAN_FRONTEND=noninteractive apt-get remove -yqq webmin && DEBIAN_FRONTEND=noninteractive apt-get install -yqq webmin \
	&& apt-get clean
EXPOSE 80
EXPOSE 21
EXPOSE 22

RUN echo "\033[1mInstalling PHP modules...\033[0m" \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
		php-curl \
		php-mysql \
	&& apt-get clean

RUN echo root:pass | chpasswd

COPY init.sh /sbin/init.sh
CMD ["/sbin/init.sh"]
