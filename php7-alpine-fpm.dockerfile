ARG PHP_VERSION=8.0
ARG ALPINE_VERSION=3.12

FROM php:${PHP_VERSION}-fpm-alpine

ENV COMPOSER_VERSION=2.0.2

# phpize 编译所需要的依赖
#ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c zlib-dev"
ENV PHPIZE_DEPS="libpng-dev libzip-dev icu-dev libxml2-dev imagemagick-dev zstd-libs zstd-libs"
# 需要使用 docker-php-ext-install 安装的扩展
# gd 所需依赖：zlib-dev libpng-dev libzip-dev
# intl 所需依赖：icu-dev
# soap 所需依赖：libxml2-dev
ENV PHP_EXT="bcmath gd intl pcntl soap sockets zip pdo_mysql"
# 需要使用 pecl 安装的扩展
# imagick 所需依赖：zstd-libs
# redis 所需依赖：zstd-libs
ENV PECL_EXT="redis xdebug imagick"

RUN set -ex \
    && apk update \
    && apk --update add autoconf g++ gcc make \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
	&& docker-php-ext-install $PHP_EXT \
	&& pecl install $PECL_EXT \
    && docker-php-ext-enable $PECL_EXT \
    # install composer
    && wget -nv -O /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod u+x /usr/local/bin/composer \
    # ---------- clear works ----------
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n" \
    && php -v \
    && php -m
