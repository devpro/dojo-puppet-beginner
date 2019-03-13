FROM alpine:latest

RUN apk add bash less gcc

RUN echo http://dl-4.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk update

RUN apk add ca-certificates pciutils
RUN apk add shadow ruby ruby-irb ruby-rdoc ruby-etc
RUN gem install puppet
RUN gem install facter

RUN apk add ruby-dev libc-dev make
RUN gem install json

RUN /usr/bin/puppet module install puppetlabs-apk

RUN mkdir /run/nginx
RUN apk add nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
