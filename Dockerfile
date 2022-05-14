FROM registry.access.redhat.com/ubi8

RUN dnf module reset php \
  && yum --disableplugin=subscription-manager -y    module enable php:7.4 \
 && yum --disableplugin=subscription-manager -y  install httpd php php-mysqlnd php-gd php-xml php-mbstring php-json mod_ssl php-intl php-apcu wget \
 && yum --disableplugin=subscription-manager -y  install systemd net-tools  mod_ssl \
 && yum --disableplugin=subscription-manager -y clean all
 
 RUN  cd /var/www/ \
      && wget https://releases.wikimedia.org/mediawiki/1.37/mediawiki-1.37.2.tar.gz \ 
      && tar -zxf mediawiki-1.37.2.tar.gz  \
      && ln -s mediawiki-1.37.2/ mediawiki 
      

RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf \
  && sed -i 's/listen.acl_users = apache,nginx/listen.acl_users =/' /etc/php-fpm.d/www.conf \
  && sed -ri -e  's!/var/www/html!/var/www/mediawiki!g'  /etc/httpd/conf/httpd.conf \
 # && sed -ri -e  's!SSLCertificate!#SSLCertificate!g'  /etc/httpd/conf.d/ssl.conf \
 # && sed -ri -e  's!SSLPassPhraseDialog!#SSLPassPhraseDialog!g'  /etc/httpd/conf.d/ssl.conf \
  && sed -ri -e  's!Listen 443 https!#Listen 443 https!g'  /etc/httpd/conf.d/ssl.conf \
 # && sed -ri -e  's!SSLEngine on!SSLEngine off!g'  /etc/httpd/conf.d/ssl.conf \
 # && mv /etc/httpd/conf.modules.d/00-ssl.conf /etc/httpd/conf.modules.d/00-ssl.conf_bkup \
  && echo "ServerName 127.0.0.1" >>  /etc/httpd/conf/httpd.conf \ 
  && mkdir /run/php-fpm \
  && chown -R apache:apache /var/www/mediawiki-1.37.2 /var/lib/php/session \
  && chgrp -R apache /var/lib/php/session \
  && chmod 1773 /var/lib/php/session  \ 
  && chgrp -R 0 /var/log/httpd /var/run/httpd /run/php-fpm \
  && chmod -R g=u /var/log/httpd /var/run/httpd /run/php-fpm


EXPOSE 8080
USER 1001
CMD php-fpm & httpd -D FOREGROUND