FROM alpine:3.8

MAINTAINER Vu Nguyen Vu <vunguyenvu35@gmail.com>

RUN apk add --update nginx
RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

ADD nginx.conf /etc/nginx/
ADD app.conf /etc/nginx/conf.d/
ADD thai.conf /etc/nginx/conf.d/

ADD upstream.conf /etc/nginx/conf.d/
ADD ssl /etc/nginx/ssl/

RUN adduser -D -g '' -G www-data www-data

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
