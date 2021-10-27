# Rgeo tracker

A service that keeps track of gps tracker movements.

## System requirements
Postgresql 10.18+
PostGIS
ruby 2.7.2+

## Installation

```bash
git clone git@github.com:SteveRedka/rgeo_gps_tracker.git
cd rgeo_gps_tracker
bundle
rake db:migrate
rails server
```

## docs
http://127.0.0.1:3000/api-docs/index.html

# Assumptions

We don't need to store data about past routes. So, when user creates data with id of existing GPS transmitter,
it simply resets its route by deleting all existing points.
