#!/bin/bash
cd /tmp
curl -LO https://ru.wordpress.org/wordpress-5.0-ru_RU.tar.gz
tar xzvf wordpress-5.0-ru_RU.tar.gz
cd wordpress
mv wp-config-sample.php wp-config.php

sed -e 's/database_name_here/wp_db/g' -e 's/username_here/admin_wp/g' -e 's/password_here/wp_password/g' -i ./wp-config.php
sed -i 's/localhost/192.168.56.10/' ./wp-config.php
cd wp-content
git clone https://github.com/kevinoid/postgresql-for-wordpress.git
mv postgresql-for-wordpress/pg4wp pg4wp
cp pg4wp/db.php db.php

sudo cp -a /tmp/wordpress/. /var/www/wordpress
sudo chown -R www-data:www-data /var/www/wordpress