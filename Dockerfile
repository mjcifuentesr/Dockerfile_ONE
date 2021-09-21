FROM amazonlinux:latest

WORKDIR /var/www/html

RUN yum update -y

#Install Tools
RUN yum install -y amazon-linux-extras \
    && amazon-linux-extras enable php7.4 \
    && yum clean metadata \
    && yum install -y php \
    php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,xdebug}

#Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && ln -s /usr/local/bin/composer /usr/bin/composer \
    && composer -v

#Install Drush
RUN composer global require consolidation/cgr \
    && PATH="$(composer config -g home)/vendor/bin:$PATH" \
    && cgr drush/drush

#Install Nginx
RUN amazon-linux-extras enable nginx1 \
    && yum clean metadata \
    && yum install -y nginx \
    && nginx -v

#Uninstall Apache
RUN yum remove -y httpd

#Install Drush
RUN composer global require consolidation/cgr \
    && PATH="$(composer config -g home)/vendor/bin:$PATH" \
    && cgr drush/drush

#Install Drupal Console
RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
    && mv drupal.phar /usr/local/bin/drupal \
    && chmod +x /usr/local/bin/drupal

WORKDIR /var/www/html

ENTRYPOINT ["/bin/bash"]
