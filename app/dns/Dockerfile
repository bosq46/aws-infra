FROM alpine:latest

RUN apk --update add bind && rm -rf /var/cache/apk/*

COPY ./conf/named.conf /etc/bind/named.conf
EXPOSE 53/udp

CMD ["/usr/sbin/named", "-c", "/etc/bind/named.conf", "-u", "named", "-g"]
