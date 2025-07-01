FROM wordpress:php8.2-fpm

# 必要に応じて拡張モジュールを追加
RUN docker-php-ext-install mysqli

# WordPress ファイルは公式イメージに含まれているので追加不要
# php-fpm はデフォルトで 9000 番ポートを使用

EXPOSE 9000

CMD ["php-fpm"]
