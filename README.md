Grape API on Rack
=================

[![Build Status:fork origin](https://secure.travis-ci.org/dblock/grape-on-rack.png)](http://travis-ci.org/dblock/grape-on-rack)
[![Build Status:master](https://travis-ci.org/nihonjinrxs/grape-on-rack.png?branch=master)](https://travis-ci.org/nihonjinrxs/grape-on-rack)
[![Build Status:activerecord-migrations](https://travis-ci.org/nihonjinrxs/grape-on-rack.png?branch=activerecord-migrations)](https://travis-ci.org/nihonjinrxs/grape-on-rack?branch=activerecord-migrations)

A [Grape](http://github.com/intridea/grape) API mounted on Rack.

* API v1: demonstrates `rescue_from` that wraps all exceptions in an HTTP error code 500
* API v2: demonstrates vendor-based versioning
* API v3: demonstrates `POST` and `PUT`
* API v4: demonstrates a middleware that wraps all responses and always returns HTTP code 200
* API v5: demonstrates a `POST` with JSON data

Run
---

```
bundle install
rackup
```

Try http://localhost:9292/api/v1/system/ping.

New Relic
---------

The application is setup with NewRelic w/ Developer Mode. Navigate to http://localhost:9292/newrelic after making some API calls.
