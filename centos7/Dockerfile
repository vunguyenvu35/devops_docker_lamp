FROM centos:7

###################################
#   AUTHOR & MAINTAINER
###################################

LABEL maintainer="Vu Nguyen Vu <vunguyenvu35@gmail.com>"
USER root
ENV HTTPD_PREFIX /usr/local/apache2
ENV HTTPD_ROOT /opt/httpd

RUN yum -y update 

###################################
#   INSTALL BUILD TZ
###################################

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###################################
#   INSTALL BUILD TOOLS
###################################

RUN yum install -y  sudo bzip2-libs bzip2 bzip2-devel ca-certificates \
        glibc gmp gnutls gmp-devel libstdc++ openldap openssl-libs \
        p11-kit readline readline-devel wget expat-devel gettext-devel \
        pcre pcre-devel openssl openssl-devel epel-release git bash \
        python-setuptools gcc gcc-c++ \
        perl-ExtUtils-MakeMaker zlib-devel curl-devel make unzip \
        libxslt-devel net-snmp-devel aspell-devel unixODBC-devel \
        libicu-devel libc-client-devel freetype-devel \
        libXpm-devel libpng-devel libvpx-devel enchant-devel \
        libcurl-devel libjpeg-turbo-devel libjpeg-devel \
        libxml2-devel pkgconfig libmcrypt-devel mariadb-devel recode-devel autoconf bison re2c \
        automake libtool nasm zlib-devel sqlite3 \
        clean all

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN easy_install supervisor

###################################
#   INSTALL crontab
###################################
RUN yum install -y cronie clean all

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
RUN mkdir "/opt/httpd"
ADD sources/httpd /opt/httpd
RUN cd "/opt/httpd" \
        # && tar -zxvf httpd-2.4.39.tar.gz \
        # && tar -zxvf apr-1.7.0.tar.gz \
        # && tar -zxvf apr-util-1.6.1.tar.gz \
        && mv apr-1.7.0 /opt/httpd/httpd-2.4.39/srclib/apr \
        && mv apr-util-1.6.1 /opt/httpd/httpd-2.4.39/srclib/apr-util \
        && cd /opt/httpd/httpd-2.4.39 \
        && ./buildconf && ./configure --enable-ssl --enable-so --with-included-apr --with-ssl=/usr/local/openssl --prefix=/usr/local/apache2 \
        && make && make install \
        && echo 'alias httpd="/usr/local/apache2/bin/httpd"' &>> /etc/profile.d/httpd.sh \
        && echo 'ServerName localhost' &>> /usr/local/apache2/conf/httpd.conf
ADD conf/httpd/ /usr/local/apache2/conf
ENV PATH "$PATH:/usr/local/apache2/bin"
# Install google mode pagespeed
# RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm \
#         &&  yum install at -y \
#         &&  rpm2cpio ./mod-pagespeed-stable_current_x86_64.rpm | cpio -idmv \
#         && cp ./usr/lib64/httpd/modules/mod_pagespeed_ap24.so /usr/local/apache2/modules/mod_pagespeed_ap24.so \
#         && cp ./usr/bin/pagespeed_js_minify /usr/local/apache2/bin/pagespeed_js_minify


###################################
#   INSTALL php-fpm 7.2
###################################

## CMake
RUN mkdir -p /tmp/cmake && \
    pushd /tmp/cmake && \
    wget 'https://cmake.org/files/v3.9/cmake-3.9.1-Linux-x86_64.sh' && \
    bash cmake-3.9.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir && \
    popd && \
    rm -rf /tmp/cmake

## Install libzip
COPY sources/php/libzip-1.5.2.tar.gz /tmp/libzip-1.5.2.tar.gz
RUN cd /tmp && tar --extract --gzip --file libzip-1.5.2.tar.gz && \
        cd /tmp/libzip-1.5.2 && \
        mkdir build && cd build && \
        cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/libzip/1_5_2 && \
        make && make install
RUN yum install -y sqlite-devel.x86_64 oniguruma-devel
## Install PHP / PHP-FPM
RUN mkdir "/opt/php"
COPY sources/php/php-7.3.12.tar.gz /opt/php/php-7.3.12.tar.gz
RUN  cd "/opt/php" \
        && tar --extract --gzip --file php-7.3.12.tar.gz \
        && cd "/opt/php/php-7.3.12" \
        && ./buildconf --force \
        && CONFIGURE_STRING="--prefix=/etc/php \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --with-bz2 \
        --with-zlib \
        --with-libzip=/usr/local/libzip/1_5_2 \
        --disable-cgi \
        --enable-soap \
        --enable-intl \
        --with-openssl \
        --with-readline \
        --with-curl \
        --enable-ftp \
        --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
        --enable-sockets \
        --enable-pcntl --with-pspell --with-enchant --with-gettext --with-gd \
        --enable-exif --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl \
        --enable-bcmath \
        --enable-mbstring \
        --enable-calendar \
        --enable-simplexml \
        --enable-json \
        --enable-hash \
        --enable-session \
        --enable-xml \
        --enable-wddx \
        --enable-opcache --with-pcre-regex --with-config-file-path=/etc/php/etc --with-config-file-scan-dir=/etc/php/etc/php.d \
        --enable-cli \
        --enable-maintainer-zts --with-tsrm-pthreads \
        --enable-debug \
        --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data" \
        && ./configure $CONFIGURE_STRING \
        && make && sudo make install \
        && chmod o+x /etc/php/bin/phpize \
        && chmod o+x /etc/php/bin/php-config
ENV PATH "$PATH:/etc/php/bin:/etc/php/sbin"
RUN echo "alias php='/etc/php/bin/php'" > /etc/profile.d/php.sh
RUN php -v

## Setup php-fpm
RUN mkdir /etc/php/etc/php.d && cd /etc/php/etc \
        && cp php-fpm.conf.default php-fpm.conf
ADD conf/php-fpm/php-fpm.conf /opt/php
RUN cp /opt/php/php-fpm.conf /etc/php/etc/php-fpm.d/php-fpm.conf

COPY conf/php.d/php.ini-production /etc/php/etc/php.ini
RUN cd /etc/init.d \
    && cp /opt/php/php-7.3.12/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm \
    && chmod +x /etc/init.d/php-fpm
## predis
RUN yum -y install re2c
RUN  cd /tmp \
        && git clone -b 'v0.13.3' https://github.com/redis/hiredis.git \
        && cd hiredis \
	&& make && make install
RUN cd /tmp \
        && git clone https://github.com/nrk/phpiredis.git \
        && cd phpiredis \
        && phpize && ./configure --enable-phpiredis \
        && make && make install
RUN touch /etc/php/etc/php.d/predis.ini \
        && echo 'extension=phpiredis' >> /etc/php/etc/php.d/predis.ini

## solr
COPY sources/php/solr-3dbdb7e.tar.gz /tmp/solr-3dbdb7e.tar.gz
RUN cd /tmp && tar --extract --gzip --file solr-3dbdb7e.tar.gz && \
        cd /tmp/solr-3dbdb7e && \
        phpize && \
        ./configure && \
        make && make install && \
        touch /etc/php/etc/php.d/solr.ini && \
        echo "extension=solr" >> /etc/php/etc/php.d/solr.ini

## php-memcached
RUN yum -y install libmemcached-devel memcached \
        clean all
RUN cd /tmp && git clone https://github.com/php-memcached-dev/php-memcached.git && cd php-memcached && \
        phpize && \
        ./configure && \
        make && make install && \
        touch /etc/php/etc/php.d/php-memcached.ini && \
        echo "extension=memcached" >> /etc/php/etc/php.d/php-memcached.ini

##  Install pthreads
# RUN mkdir "/opt/php/pthreads" \
#         && cd "/opt/php/pthreads" \
#         && git clone https://github.com/krakjoe/pthreads.git . \
#         && phpize && ./configure --with-php-config=/etc/php/bin/php-config && make && make install && \
#         touch /etc/php/etc/php.d/pthreads.ini

###################################
#   SET UP CRONTAB 
###################################
# RUN echo "* * * * * /etc/php/bin/php /usr/local/apache2/htdocs/app/artisan schedule:run >> /var/log/crond-stderr.log 2>&1" >>  /etc/crontab

###################################
#   INSTALL COMPOSER
###################################
ADD composer.phar composer.phar 
RUN chmod 755 composer.phar \
        && mv composer.phar /usr/local/bin/composer \
        && composer --version
        
# Working dir
RUN mkdir $HTTPD_PREFIX/htdocs/app
WORKDIR $HTTPD_PREFIX/htdocs/app

# Run
COPY docker-entrypoint.sh /usr/local/bin/
RUN sed -i -e 's/\r$//' /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
EXPOSE 80 443