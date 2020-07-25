bash /usr/local/bin/install-symfony.sh
mv /root/.symfony/bin/symfony /usr/local/bin/symfony
# apt-get update && apt-get install git
# cd /var && composer create-project symfony/website-skeleton


merge https://raw.githubusercontent.com/symfony/website-skeleton/5.1/composer.json
# ! composer.json wasn't synced with current docker-compose settings
# using complete sync: ./:/var/www
rm composer.lock
# (rename public/index.php to have it autocreated)
composer install
chown -R 1000:1000 *
add new files to git
