FROM centos:7

###################################
#   AUTHOR & MAINTAINER
###################################

LABEL maintainer="Vu Nguyen Vu <vunguyenvu35@gmail.com>"

ENV HTTPD_PREFIX /usr/local/apache2
ENV HTTPD_ROOT /opt/httpd

RUN yum -y update 

###################################
#   INSTALL BUILD TOOLS
###################################

RUN yum install -y  bzip2-libs  \
                    bzip2 \
                    ca-certificates \
                    glibc gmp gnutls \
                    libstdc++ openldap \
                    openssl-libs \
                    p11-kit pcre \
                    readline \
                    wget \
                    expat-devel \
                    gettext-devel \
                    pcre \
                    pcre-devel \
                    openssl \
                    openssl-devel \
                    epel-release \
                    git \
                    bash \
                    python-setuptools \
                    gcc \
                    gcc-c++ \
                    perl-ExtUtils-MakeMaker \
                    zlib-devel \
                    curl-devel \
                    make \
                    unzip

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN easy_install supervisor

###################################
#   ENV
###################################

ENV HTTPD_PREFIX /usr/local/apache2

###################################
#   INSTALL APAHCE 2.4
###################################

RUN yum groupinstall " Development Tools"  -y
RUN yum install expat-devel pcre pcre-devel openssl-devel -y
SHELL ["/bin/bash", "-c"]
RUN mkdir "/opt/httpd" \
        && cd "/opt/httpd" \
        && wget http://mirrors.viethosting.com/apache/httpd/httpd-2.4.39.tar.gz -O httpd-2.4.39.tar.gz \
        && wget https://github.com/apache/apr/archive/1.7.0.tar.gz -O apr-1.7.0.tar.gz \
        && wget https://github.com/apache/apr-util/archive/1.6.1.tar.gz -O apr-util-1.6.1.tar.gz \
        && tar -zxvf httpd-2.4.39.tar.gz \
        && tar -zxvf apr-1.7.0.tar.gz \
        && tar -zxvf apr-util-1.6.1.tar.gz \
        && mv apr-1.7.0 /opt/httpd/httpd-2.4.39/srclib/apr \
        && mv apr-util-1.6.1 /opt/httpd/httpd-2.4.39/srclib/apr-util \
        && cd /opt/httpd/httpd-2.4.39 \
        && ./buildconf && ./configure --enable-ssl --enable-so --with-included-apr --with-ssl=/usr/local/openssl --prefix=/usr/local/apache2 \
        && make && make install \
        && echo 'alias httpd="/usr/local/apache2/bin/httpd"' &>> /etc/profile.d/httpd.sh \
        && echo 'ServerName localhost' &>> /usr/local/apache2/conf/httpd.conf 

ADD conf/httpd/ /usr/local/apache2/conf

###################################
#   INSTALL php-fpm 7.2
###################################

RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72 
RUN yum --enablerepo=remi,remi-php72 install -y php-fpm \
        php-common \
        php-opcache \
        php-pecl-apcu \
        php-cli \
        php-pear \
        php-devel \
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

ADD conf/php-fpm/php-7.2.ini /etc/php.d
ADD conf/php-fpm/php-7.2.ini /etc/php/conf.d/
ADD conf/php-fpm/php-7.2.ini /etc/php/cli/conf.d/
RUN rm /etc/php-fpm.d/www.conf
ADD conf/php-fpm/php-fpm-7.2.conf /etc/php-fpm.d/
RUN php -v
RUN mkdir /run/php-fpm
RUN chmod -R 755  /run/php-fpm root root

###################################
#   INSTALL COMPOSER
###################################

# install composer 
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Working dir
RUN mkdir $HTTPD_PREFIX/htdocs/app
WORKDIR $HTTPD_PREFIX/htdocs/app

# Run
COPY supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
EXPOSE 80