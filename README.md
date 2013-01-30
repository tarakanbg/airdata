# Airdata

Rails engine for adding aviation related models and data to a web application.

It will add 3 Active Record models to your rails application: `Airports`, `Runways`
and `Waypoints` (including Navaids). It will add the corresponding database
structure (migrations) and finally it will populate the corresponding tables of
your database with [data](#data-stats) (based on *AIRAC cycle 1301*.)

[![Build Status](https://secure.travis-ci.org/tarakanbg/airdata.png)](http://travis-ci.org/tarakanbg/airdata)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/tarakanbg/airdata)
[![Gemnasium](https://gemnasium.com/tarakanbg/airdata.png?travis)](https://gemnasium.com/tarakanbg/airdata)
[![Gem Version](https://badge.fury.io/rb/airdata.png)](http://badge.fury.io/rb/airdata)

## Disclaimer

**This database is designed for training, education and flight simulation purposes! Its contents might be outdated
and shall not be used for real world navigation and flight as it is unlawful and unsafe to do so!**

## Installation within parent app

Add this gem AND the `activerecord-import` your application's Gemfile:

    gem 'airdata'
    gem "activerecord-import", "~> 0.3.0"  # Required for the data import

And then execute:

    $ bundle

Run the following commands in your app directory:

```sh
rake airdata:install:migrations
rake db:migrate
rake airdata:setup
```

### Updating the data

You can get information about your currently installed AIRAC cycle and the
latest available one by running:

```sh
rake airdata:cycle  # =>

  Currently instaled AIRAC cycle: 1301
  Latest available AIRAC cycle: 1301

  No update is necessary!

# Or if there's a newer verion available:
rake airdata:cycle  # =>

  There's a newer cycle available.
  You can update by running: rake airdata:update
```

If you want to do a data update to a newer AIRAC cycle, run the following
rake task for clearing up the old data and re-injecting the current one:

```sh
rake airdata:update
```

## Data stats

* Airports: 10775
* Runways: 28977
* Navaids: 16300
* Waypoints: 214400

* Total DB records: 270472

All data is derrived and compiled from public sources such as:
[OurAirports](http://www.ourairports.com/data/) and
[OpenFlights](http://openflights.org/data.html)

## Lib classes

2 classes handle the heavy lifting of downloading, parsing and injecting the data
within you local database: `Airdata::DataDownloader` and `Airdata::DataInjector`.
Generally you won't need to deal with them directly. All the functionality you
need to install is triggered via rake tasks and almost nothing there is
considered public API, apart from the following public class methods:

```ruby
  # Returns the currently installed AIRAC cycle:
  Airdata::DataDownloader.cycle # => 1208

  # Returns the latest available for download AIRAC cycle:
  Airdata::DataDownloader.latest_cycle # => 1301
```

## Models and their attributes

These AR models and attribute sets will be available in your parent app,
namespaced within the `Airdata` module and accessible like this:

```ruby
 Airdata::Airports
 Airdata::Runways
 Airdata::Waypoints
```
Currently there are no special public methods/APIs available for these models,
the engine is tailored primarily for data storage and access.

### Ordering

Default ordering is implemented for all 3 classes. Airports and waypoints are
sorted *alphabetically* i.e. ordered by `id`, and the runways are ordered by their
`airport_id`. Remember you can always override the default ordering by using Active
Record's `.reorder` [method](http://guides.rubyonrails.org/active_record_querying.html#ordering)

### Airports

Includes one-to-many association with the `Runways` class.

```ruby
attr_accessible :elevation, :icao, :lat, :lon, :msa, :name, :ta

has_many :runways, :dependent => :destroy
```
* ICAO
* Name (city)
* Latitude
* Longitude
* Elevation
* Transition altitude
* Minimum safe altitude

### Runways

Includes one-to-many association with the `Airports` models.

```ruby
attr_accessible :airport_id, :course, :elevation, :glidepath, :ils, :ils_fac
attr_accessible :ils_freq, :lat, :length, :lon, :number

belongs_to :airport
```

* airport_id (association)
* number
* course
* elevation
* glidepath angle
* ILS (boolean)
* ILS final approach course
* ILS frequency
* latitude on the threshold
* longitude on the threshold
* length

### Waypoints (includes Navaids)

Regular waypoints only include `:ident, :lat, :lon, :country_code`. The rest is
for navaids.

```ruby
attr_accessible :country_code, :elevation, :freq, :ident, :lat, :lon, :name, :range
```

* ident
* name
* frequency
* country code
* elevation
* latitude
* longitude
* range (in MSFS)

## Rake tasks

Here's a lisk of all rake tasks that this gem adds:

```sh
rake airdata:install:migrations  # Copy migrations from airdata to application.
                                 # This is part of the initial install process.
rake airdata:setup               # Downloads and installs the latest navdata
rake airdata:cycle               # Compares your currently installed AIRAC cycle
                                 # agianst the latest available
rake airdata:truncate            # Truncate navadata tables, populated by Airdata.
                                 # Generally you don't need to run this separately,
                                 # it's automatically called during data updates
rake airdata:update              # Removes old Airdata and installs latest available
                                 # Essentially it runs the truncate task followed by the setup

```

## Changelog

### v. 0.3, 30 January 2013

* moved away from the deprecated github downloads
* updated dependencies

### v. 0.2, 29 August 2012

* added default ordering for all 3 models. Airports and waypoints/navaids are
sorted by `id`, runways are sorted by `airport_id`

## Credits

Copyright © 2013 [Svilen Vassilev](http://svilen.rubystudio.net)

*If you find my work useful or time-saving, you can endorse it or buy me a beer:*

[![endorse](http://api.coderwall.com/svilenv/endorsecount.png)](http://coderwall.com/svilenv)
[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5FR7AQA4PLD8A)

Released under the [MIT LICENSE](https://github.com/tarakanbg/airdata/blob/master/LICENSE)
