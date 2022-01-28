# Lamp-stack-on-archlinux

<div align="center">
    <a href="https://lamp.sh/" target="_blank">
        <img alt="LAMP" src="https://github.com/teddysun/lamp/blob/master/conf/lamp.png">
    </a>
</div>

## Description

[Lamp-stack-on-archlinux](https://github.com/henry-jacq/lamp-on-arch/) is a powerful bash script for the installation of Apache + PHP + MySQL/MariaDB on top of arch linux. You can install Apache + PHP + MySQL/MariaDB in an very easy way, And all things will be done in few minutes.

This script allows user to install LAMP (Linux + Apache + Mysql + php) on Arch Linux

> Note:-
>       This script only runs on arch-based distributions only


## Supported Software

- Apache-2.4 (Include HTTP/2 module: [nghttp2](https://github.com/nghttp2/nghttp2), [mod_http2](https://httpd.apache.org/docs/2.4/mod/mod_http2.html))
- Apache Additional Modules: [mod_wsgi](https://github.com/GrahamDumpleton/mod_wsgi), [mod_security](https://github.com/SpiderLabs/ModSecurity), [mod_jk](https://tomcat.apache.org/download-connectors.cgi)
- MySQL-5.7.35-1, MariaDB-10.6.5-2
- PHP-7.4, PHP-8.0
- PHP Additional extensions: [Zend OPcache](https://www.php.net/manual/en/book.opcache.php), [ionCube Loader](https://www.ioncube.com/loaders.php), [PDFlib](https://www.pdflib.com/), [XCache](https://xcache.lighttpd.net/), [APCu](https://pecl.php.net/package/APCu), [imagick](https://pecl.php.net/package/imagick), [gmagick](https://pecl.php.net/package/gmagick), [libsodium](https://github.com/jedisct1/libsodium-php), [memcached](https://github.com/php-memcached-dev/php-memcached), [redis](https://github.com/phpredis/phpredis), [mongodb](https://pecl.php.net/package/mongodb), [swoole](https://github.com/swoole/swoole-src), [yaf](https://github.com/laruence/yaf), [yar](https://github.com/laruence/yar), [msgpack](https://pecl.php.net/package/msgpack), [psr](https://github.com/jbboehr/php-psr), [phalcon](https://github.com/phalcon/cphalcon), [grpc](https://github.com/grpc/grpc), [xdebug](https://github.com/xdebug/xdebug)
- Other Software: [OpenSSL](https://github.com/openssl/openssl), [ImageMagick](https://github.com/ImageMagick/ImageMagick), [GraphicsMagick](http://www.graphicsmagick.org/), [Memcached](https://github.com/memcached/memcached), [phpMyAdmin](https://github.com/phpmyadmin/phpmyadmin), [Adminer](https://github.com/vrana/adminer), [Redis](https://github.com/redis/redis), [re2c](https://github.com/skvadrik/re2c), [KodExplorer](https://github.com/kalcaddle/KodExplorer)


## Software Version

| Apache & Additional Modules   | Version                                                   |
|-------------------------------|-----------------------------------------------------------|
| httpd                         | 2.4.52                                                    |
| apr                           | 1.7.0                                                     |
| apr-util                      | 1.6.1                                                     |
| nghttp2                       | 1.46.0                                                    |
| openssl                       | 1.1.1l                                                    |
| mod_wsgi                      | 4.9.0                                                     |
| mod_security2                 | 2.9.5                                                     |
| mod_jk                        | 1.2.48                                                    |

| Database                      | Version                                                   |
|-------------------------------|-----------------------------------------------------------|
| MySQL                         | 5.7.35-1                                                  |
| MariaDB                       | 10.6.5-2                                                  |

| PHP & Additional extensions   | Version                                                   |
|-------------------------------|-----------------------------------------------------------|
| PHP                           | 5.6.40, 7.0.33, 7.1.33, 7.2.34, 7.3.33, 7.4.27, 8.0.14    |
| ImageMagick                   | 7.1.0-19                                                  |
| gmagick extension (PHP 7.0+)  | 2.0.6RC1                                                  |
| mongodb extension             | 1.12.0                                                    |
| swoole extension (PHP 7.2+)   | 4.8.6                                                     |
| yaf extension (PHP 7.0+)      | 3.3.4                                                     |
| yar extension (PHP 7.0+)      | 2.2.1                                                     |
| msgpack extension (PHP 7.0+)  | 2.1.2                                                     |
| psr extension (PHP 7.2+)      | 1.2.0                                                     |
| phalcon extension (PHP 7.3+)  | 4.1.2                                                     |
| xdebug extension (PHP 5.6)    | 2.5.5                                                     |
| xdebug extension (PHP 7.0+)   | 2.9.8                                                     |
| xdebug extension (PHP 8.0+)   | 3.0.4                                                     |

| Database Management Tools     | Version                                                   |
|-------------------------------|-----------------------------------------------------------|
| phpMyAdmin (PHP 7.3+)         | 5.1.2                                                     |
| Adminer                       | 4.8.1                                                     |

