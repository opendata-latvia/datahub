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
* `bundle`

Create MySQL database schema

* `rake db:create`
* `rake db:migrate`

Running tests

* Run all tests with `rake spec`
* Run tests after each file change with `bundle exec guard`
