FROM php:7.2.2-apache-stretch AS php_apache_db2

ENV IBM_DB_HOME /opt/ibm/dsdriver
ENV LD_LIBRARY_PATH $IBM_DB_HOME/lib

RUN apt-get update && apt-get install -y \
apt-utils \
# The driver installation script is written in Korn shell.
ksh \
# Needed by the driver installation script.
unzip 

# Install the driver.
RUN mkdir /opt/ibm
COPY php_apache/ibm_data_server_driver_package_linuxx64_v11.5.tar.gz /opt/ibm/
RUN cd /opt/ibm && tar -xvf ibm_data_server_driver_package_linuxx64_v11.5.tar.gz
RUN ksh /opt/ibm/dsdriver/installDSDriver

# Install the ibm_db2 PHP extensions.
RUN echo $IBM_DB_HOME | pecl install ibm_db2-2.0.8
RUN docker-php-ext-enable ibm_db2
RUN export LD_LIBRARY_PATH=$IBM_DB_HOME/lib

# Install and configure xdebug.
RUN pecl install xdebug &&\
docker-php-ext-enable xdebug &&\
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.profiler_enable_trigger_value=XDEBUG_PROFILE" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Clean up.
RUN rm -r /tmp/*

# Update the default apache site.
ADD php_apache/conf/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Copy the index.php file, a.k.a. The «API».
COPY src/index.php /var/www/html/

CMD ["apache2-foreground"]