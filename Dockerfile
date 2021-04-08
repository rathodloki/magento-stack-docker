FROM ubuntu:18.04

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt  install wget mariadb-server apache2 php unzip  php-bcmath php-curl php-gd php-intl php-mbstring php-mysql php-soap php-zip php-common php-xml php-opcache -y
RUN adduser magento && \
    usermod -a -G www-data magento
    RUN  mkdir /var/www/magento && \
        chown magento:www-data /var/www/magento

WORKDIR /var/www/magento/

RUN wget https://getcomposer.org/composer-1.phar && \
    chmod 755 composer-1.phar && \
    mv composer-1.phar /usr/local/bin/composer
 
RUN mkdir -p /root/.composer && echo '{ "http-basic": { "repo.magento.com": { "username": ${username}, "password": ${password} }}}' > ~/.composer/auth.json

RUN service mysql start && \
    service mysql status && \
    echo "CREATE DATABASE magentodb;" | mysql -u root -P 3306  && \
    echo "GRANT ALL ON magentodb.* TO magento@localhost IDENTIFIED BY '${dbPassword}';" | mysql -u root -P 3306
    #composer create-project --repository=https://repo.magento.com/ magento/project-community-edition:2.3.1  /var/www/magento/
RUN chmod -R +777 /var/www/magento/

RUN passwd root -d
RUN apt install ssh cron vim -y
RUN sed -i 's+#PermitRootLogin prohibit-password+PermitRootLogin yes+g' /etc/ssh/sshd_config
EXPOSE 22

ADD ./dependencies/apache2.conf /etc/apache2/
RUN a2enmod rewrite

CMD apachectl restart && \
    service mysql start && \
    service ssh start &&\
    /usr/sbin/cron -n &&\
    tail -f /var/log/apache2/access.log
