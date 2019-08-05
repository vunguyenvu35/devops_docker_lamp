#!/bin/bash
cd /usr/local/apache2/htdocs/app
rm -rf *
# git clone https://$GIT_USERNAME:$GIT_PASSWORD@$GIT_URL .
git clone https://vu_vu:Vunguyenvu19966@redmine.ig.webike.net/gitbucket/git/BSS/BSS_HK_Front.git .
chmod -R 777 *
cp .env.example .env
composer install
php artisan key:generate