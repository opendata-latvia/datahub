data.opendata.lv
================

DataHub is Ruby on Rails application that powers http://data.opendata.lv.

Development environment preparation
-----------------------------------

Prerequisites

* Ruby 1.9.3
* MySQL
* Redis

Get repository and get Ruby gem dependencies

* `git clone git@github.com:opendata-latvia/datahub.git`
* `cd datahub`
* `gem install bundler`
* `bundle`

Create and verify configuration files

* `cp config/application.sample.yml config/application.yml`
* `cp config/database.sample.yml config/database.yml`

Create MySQL database schema

* `rake db:create`
* `rake db:migrate`

Create MySQL data warehouse schema (where dataset tables will be created)

* `rake db:create RAILS_ENV=development_dwh`
* `rake db:create RAILS_ENV=test_dwh`

Running tests

* Run all tests with `rake spec`
* Run tests after each file change with `bundle exec guard`

License
-------

DataHub is released under the MIT license (see file LICENSE).
