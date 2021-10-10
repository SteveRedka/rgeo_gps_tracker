# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Assumptions

We don't need to store data about past routes. So, when user creates data with id of existing GPS transmitter,
it simply resets its route by deleting all existing points.
