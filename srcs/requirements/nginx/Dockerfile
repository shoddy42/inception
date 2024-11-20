FROM alpine:3.19

RUN apk update && apk upgrade && apk --no-cache add nginx openssl

# RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 42 -newkey rsa:2048 -keyout /etc/ssl/42.wkonings.fr.key -out /etc/ssl/42.wkonings.fr.csr -subj "/C=NL/L=Amsterdam/O=Codam/OU=wkonings/CN=Wouter Konings"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
# RUN chmod +x /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
