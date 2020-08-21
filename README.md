# php-heroku-boilerplate

Provides a minimal structure for a local-dockerized PHP project targeted for Heroku.

## Consider

* Is this public, incognito or private

* [Review and edit app.json](app.json)
    * for [addons](https://elements.heroku.com/addons)
    * description
    * and check if `heroku.yml` is already widely supported and you wanted to migrate
    
* [Review and edit composer.json](composer.json)
    * author
    * autoload namespace
    * name, description, keywords
    * [license](https://help.github.com/articles/licensing-a-repository/#searching-github-by-license-type)
    * requirements: versions still valid?
    
* [Choose](https://choosealicense.com/) a [license](LICENSE)

* [Review and edit docker-compose.yml](docker-compose.yml)
    * services: which are needed, which are not
    * environment variables
    
* [Review and edit .gitignore](.gitignore)  
    * add more for Symfony et alia?
    
* [Review and edit Procfile](Procfile)  
    * still fine to use nginx?
    * and check if `heroku.yml` is already widely supported and you wanted to migrate
    
* Review and edit cnfiguration files or variables
    * consider to log to `php://stderr` and/or stdout
        * as it's docker and 12-factor standard

## Setup

* Setup git:
    * clone this boilerplate
        * ```bash
          NEW_PROJECT_NAME=FOOBAR; \
          git clone https://github.com/ebln/php-heroku-boilerplate.git ${NEW_PROJECT_NAME} && cd ${NEW_PROJECT_NAME}  
          ```
          * optional `rm -rf .git && git init` # to flush boilerplate's git history
    * or `git init;`
    * configure git for your privacy demands
        ```bash
        git remote remove origin; \
        git config --list; \
        git config user.email "sokolow@net.invalid"; \
        git config user.name "Распутин"; \
        git config --list --show-origin;
        ```
    * if this is a new repository, run:
        * `git add -A && git commit -m 'Initial commit'`
    * Create a new (origin) repository
    * ```bash
      REPOSITORY_NAME=FOOBAR; \
      git remote add origin git@github.com-ebln:ebln/${REPOSITORY_NAME}.git
      ```
    * and push `git push -u origin master`
        
* Setup docker and debug prerequisites
    * add `127.0.0.1	php.local` to `/etc/hosts`
    * to use xdebug export your local IP: `export XDEBUG_REMOTE_HOST=10.0.0.1`
        * un Linux you may also add `export XDEBUG_REMOTE_HOST=$(ip route | grep docker0 | awk '{print $9}')` to your `.bashrc`
    
* Setup Heroku
    * assuming Heroku CLI was installed
        * `sudo snap install heroku --classic`
        * `heroku login`
    * Create app
        * `heroku apps:create --region eu`
        * **CAVEAT:** auto-provision of addons and env·s via app.json seems not to work with git deployments
    * Provisioning app
        * add addons
        * add environment variables
        * either via web interface or CLI
      
 * Setup code
      ```bash
      composer.phar install && git add composer.lock && git commit -m 'Add composer.lock'
      ```
* Push to Heroku
    * for Symfony 4+ set these environment variables
        * `heroku config:set APP_SECRET=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32) APP_ENV=prod`
    * `git push heroku master` deploys to Heroku
      * or `git push heroku HEAD:master --force` to deploy the current branch
    * check `heroku open`

* Use Docker for local development
    * `docker-compose up -d` or use `make up`
    * application at http://php.local:8080
    * Adminer http://localhost:8081/?pgsql=db&username=postgres
    
* Docker clean-up
    * `docker system prune --all` (keeps data volumes)
    * `docker system prune --all  --volumes` (deletes data volumes)
    
## Installing Symfony 5
* Forget about:
  * Symfony CLI tool (~installer)
    * if you still go with it you might need `apt-get update && apt-get install git`
   * also a plain `cd /var && composer create-project symfony/website-skeleton` doesn't work well with non-empty directories.
* Alter your `docker-compose.yml` and ensure that it's synced into the container
* Merge the contents of https://raw.githubusercontent.com/symfony/website-skeleton/5.1/composer.json into your own `docker-compose.yml`
  * reorder your `docker-compose.yml` before to match the order of the website-skeleton to ease the merging
* Rename or delete `public/index.php` to enable the creation of the Symfony's one
* Delete your lock file: `rm composer.lock`
* Run `composer install` inside the container
* Do `chown -R 1000:1000 *`
* Add all new files to git
* Change the `Procfile` to `web: vendor/bin/heroku-php-nginx -C .provision/heroku-symfony-nginx.conf public/`
* Review and edit configuration files or variables
  * log to `php://stderr` and/or stdout
    * https://devcenter.heroku.com/articles/deploying-symfony4#logging
  * Trusting the Load Balancer
    * https://devcenter.heroku.com/articles/deploying-symfony4#trusting-the-heroku-router
  * Additional reads
    * Steps to start with Postgres
      * http://chrishodgsonweb.co.uk/symfony/2018/05/17/symfony4-postgress/
      * https://www.orbitale.io/2018/01/05/deploy-a-symfony-flex-project-on-heroku.html#install-a-database
