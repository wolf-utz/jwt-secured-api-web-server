FROM php:7.4-apache
RUN apt-get update \
    && apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
        curl \
        libfreetype6-dev \
        libxml2-dev \
        libmcrypt-dev \
        zlib1g-dev \
        libzip-dev \
        zip \
        git \
	# Install PHP extensions.
	&& docker-php-ext-install -j$(nproc) \
        zip \
        pdo_mysql \
        intl \
        zlib \
    # Add composer.
	&& curl -sS https:/getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	# Configure apache.
	&& a2enmod rewrite
# Add custom php.ini.
ADD ./php.ini /usr/local/etc/php/conf.d/z99-additional-php.ini
# Add vhost.
ADD ./vhost.conf /etc/apache2/sites-enabled/000-default.conf
# Clean up.
RUN apt-get clean \
    && apt-get -y purge \
        curl \
        libfreetype6-dev \
        libxml2-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /usr/src/*
# Configure volumes.
VOLUME /var/www/html