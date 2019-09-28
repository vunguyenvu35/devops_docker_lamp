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
        automake libtool nasm zlib-devel \
        clean all

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

# ADD conf/httpd/ /usr/local/apache2/conf
# Install google mode pagespeed
# RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm \
#         &&  yum install at -y \
#         &&  rpm2cpio ./mod-pagespeed-stable_current_x86_64.rpm | cpio -idmv \
#         && cp ./usr/lib64/httpd/modules/mod_pagespeed_ap24.so /usr/local/apache2/modules/mod_pagespeed_ap24.so \
#         && cp ./usr/bin/pagespeed_js_minify /usr/local/apache2/bin/pagespeed_js_minify


###################################
#   INSTALL php-fpm 7.2
###################################

RUN mkdir "/opt/php" \
        && cd "/opt/php" \
        && wget https://github.com/php/php-src/archive/php-7.2.23.tar.gz \
        && tar --extract --gzip --file php-7.2.23.tar.gz \
        && cd "/opt/php/php-src-php-7.2.23" \
        && ./buildconf --force \
        && CONFIGURE_STRING="--prefix=/etc/php --with-bz2 --with-zlib --enable-zip --disable-cgi \
        --enable-soap --enable-intl --with-openssl --with-readline --with-curl \
        --enable-ftp --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
        --enable-sockets --enable-pcntl --with-pspell --with-enchant --with-gettext \
        --with-gd --enable-exif --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl \
        --enable-bcmath --enable-mbstring --enable-calendar --enable-simplexml --enable-json \
        --enable-hash --enable-session --enable-xml --enable-wddx --enable-opcache \
        --with-pcre-regex --with-config-file-path=/etc/php/etc \
        --with-config-file-scan-dir=/etc/php/etc --enable-cli --enable-pthreads=shared --enable-maintainer-zts \
        --with-tsrm-pthreads --enable-debug --enable-fpm \
        --with-fpm-user=www-data --with-fpm-group=www-data" \
        && ./configure $CONFIGURE_STRING \
        && make && sudo make install \
        && chmod o+x /etc/php/bin/phpize \
        && chmod o+x /etc/php/bin/php-config

# Setup php-fpm
RUN mkdir /etc/php/etc/php.d \
        &&cd /etc/php/etc \
        && cp php-fpm.conf.default php-fpm.conf
ADD conf/php-fpm/php-fpm.conf /opt/php
RUN cp /opt/php/php-fpm.conf /etc/php/etc/php-fpm.d/php-fpm.conf \
        && cp /opt/php/php-src-php-7.2.23/php.ini-production /etc/php/etc/php.ini
RUN cd /etc/init.d \
    && cp /opt/php/php-src-php-7.2.23/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm \
    && chmod +x /etc/init.d/php-fpm
RUN echo "alias php='/etc/php/bin/php'" > /etc/profile.d/php.sh
ENV PATH "$PATH:/etc/php/bin"
RUN php -v

# Install ptheads
RUN mkdir "/opt/php/pthreads" \
        && cd "/opt/php/pthreads" \
        && git clone https://github.com/krakjoe/pthreads.git . \
        && phpize && ./configure --with-php-config=/etc/php/bin/php-config && make install
# RUN echo "extension=pthreads" >> /etc/php/etc/php.ini

# ADD conf/php-fpm/php-7.2.ini /etc/php.d
# ADD conf/php-fpm/php-7.2.ini /etc/php/conf.d/
# ADD conf/php-fpm/php-7.2.ini /etc/php/cli/conf.d/
# RUN rm /etc/php-fpm.d/www.conf
# RUN mkdir /run/php-fpm
# RUN chmod -R 755  /run/php-fpm root root

###################################
#   INSTALL COMPOSER
###################################
ADD composer.phar composer.phar 
RUN mv composer.phar /usr/local/bin/composer
RUN composer --version
###################################
#   INSTALL crontab
###################################
RUN yum install -y cronie

# Working dir
RUN mkdir $HTTPD_PREFIX/htdocs/app
WORKDIR $HTTPD_PREFIX/htdocs/app

# Run
# COPY supervisord.conf /etc/supervisor/supervisord.conf
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
# ENTRYPOINT  ["/bin/bash", "-c", "/etc/init.d/php-fpm start && crond && /usr/local/apache2/bin/httpd -D FOREGROUND && tail -f /dev/null"]
COPY docker-entrypoint.sh /usr/local/bin/
RUN sed -i -e 's/\r$//' /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/docker-entrypoint.sh start"]
CMD ["--no-daemonize"]
EXPOSE 80