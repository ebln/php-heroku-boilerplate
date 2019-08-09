# php-heroku-boilerplate

Provides a minimal structure for a local-dockerized php project targeted for Heroku.

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
    * consider to log to php://stderr (and/or stdout) in production
        * https://devcenter.heroku.com/articles/getting-started-with-symfony#changing-the-log-destination-for-production
    * Symfony 4:
        * Trusting the Load Balancer
            * https://devcenter.heroku.com/articles/getting-started-with-symfony#ctrusting-the-load-balancer
        * Steps to start with Postgres
            * http://chrishodgsonweb.co.uk/symfony/2018/05/17/symfony4-postgress/
            * https://www.orbitale.io/2018/01/05/deploy-a-symfony-flex-project-on-heroku.html#install-a-database
            

## Setup

* Setup git:
    * clone this boilerplate
        * ```bash
          NEW_PROJECT_NAME=FOOBAR; \
          git clone https://github.com/ebln/php-heroku-boilerplate.git ${NEW_PROJECT_NAME} && cd ${NEW_PROJECT_NAME}  
          ```
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
      git remote set-url origin git@github.com-ebln:ebln/${REPOSITORY_NAME}  
      ```
    * and push `git push -u origin master`
        
* Setup docker and debug prerequisites
    * add `127.0.0.1	php.local` to `/etc/hosts`
    * to use xdebug export your local IP: `export XDEBUG_REMOTE_HOST=10.0.0.1`
    
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
    * for Symfony 4 set these environment variables
        * `heroku config:set APP_ENV=prod APP_SECRET=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)`
    * `git push heroku master`
    * check `heroku open`

* Use Docker for local development
    * `docker-compose up -d`
    * application at http://php.local:8080
    * Adminer http://localhost:8081/?pgsql=db&username=postgres
    
* Docker clean-up
    * `docker system prune --all` (keeps data volumes)
    * `docker system prune --all  --volumes` (deletes data volumes)
    
