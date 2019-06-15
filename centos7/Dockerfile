FROM centos:7
LABEL maintainer="Vu Nguyen Vu <vunguyenvu35@gmail.com>"

ENV HTTPD_PREFIX /usr/local/apache2

RUN yum -y update 
RUN yum install -y bzip2-libs ca-certificates glibc gmp gnutls libstdc++ openldap openssl-libs p11-kit pcre readline wget
RUN yum install -y expat-devel pcre pcre-devel openssl-devel -y
RUN yum install -y epel-release git bash

# In stall httpd
ADD install-httpd.sh /
RUN chmod +x /install-httpd.sh
RUN sed -i 's/\r//' /install-httpd.sh
RUN bash -c "/install-httpd.sh"
ADD conf/httpd/ /usr/local/apache2/conf

# install php-fpm 7.2
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72 
RUN yum --enablerepo=remi,remi-php72 install -y php-fpm \
        php-common \
        php-opcache \
        php-pecl-apcu \
        php-cli \
        php-pear \
        php-pdo \
        php-mysqlnd \
        php-pgsql \
        php-pecl-mongodb \
        php-pecl-redis \
        php-pecl-memcache \
        php-pecl-memcached \
        php-pecl-solr2 \
        php-xmlwriter \
        php-gd \
        php-mbstring \
        php-mcrypt \
        php-xml \
        php-dev \
        php-json \
        php-iconv \
        php-mysqli \
        php-dom \
        php-zip \
        libmcrypt-dev \
        make \
        curl 
ADD conf/php-fpm/php-7.2.ini /etc/php/conf.d/
ADD conf/php-fpm/php-7.2.ini /etc/php/cli/conf.d/
RUN rm /etc/php-fpm.d/www.conf
ADD conf/php-fpm/php-fpm-7.2.conf /etc/php-fpm.d/
RUN php -v
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN mkdir /run/php-fpm
RUN chmod -R 755  /run/php-fpm root root

# Working dir
WORKDIR $HTTPD_PREFIX
# Run
ADD run-httpd.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-httpd.sh
RUN sed -i 's/\r//' /usr/local/bin/run-httpd.sh
ENTRYPOINT ["sh", "/usr/local/bin/run-httpd.sh"]
EXPOSE 80