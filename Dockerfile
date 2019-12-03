FROM php:7.3-fpm

LABEL maintainer xieyutian "xieyutianhn@gmail.com"

#软件源获取
RUN apt-get update 

#composer 安装
RUN curl -O https://getcomposer.org/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/bin/composer \
    && composer config -g repo.packagist composer https://packagist.laravel-china.org

#swoole 线上安装 
RUN apt-get install git -y \
    &&  git clone https://gitee.com/swoole/swoole.git swoole \
    && apt-get install libssl-dev -y \
    && cd swoole \
    && phpize \
    && ./configure --enable-openssl \
    && make \
    && make install \
    && cd .. \
    && docker-php-ext-enable swoole \
    && rm -rf swoole

# xdebug 安装 
RUN git clone https://github.com/xdebug/xdebug \
    && cd xdebug \
    && ./rebuild.sh \
    && docker-php-ext-enable xdebug \
    && cd ..\
    && rm -rf xdebug

# 开启 mysqli 
RUN docker-php-ext-install mysqli

# 以root运行并强制前端运行
CMD php-fpm -RF