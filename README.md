## Crypto-trading bot based on dry-rb stack and celluloid

  - [First time setup](#first-time-setup)

## First time setup

1. Rename ruby container image in docker-compose.yml
2. Create .env files in .config/environments by existing examples
3. Run following commands in project folder
```
    $ docker-compose build
    $ docker-compose run ruby bundle
    $ touch /usr/src/app/log/api_development.log
    $ touch /usr/src/app/log/parser_development.log
    $ docker-compose up -d
```
4. Connect to ruby container, create DB and run migrations
```
    $ docker exec -it crypto_ruby_1 bash
    $ bundle exec rack db:create
    $ bundle exec rack db:migrate
```
5. Run app console and call 'run_bot' transaction with empty args
```
    $ ./bin/console_parser

    irb> App::Container['transactions.run_bot'].call ''
```
