# Airdata

Rails engine for adding aviation related models and data to a web application

### Here be dragons!

**Work in progress: not supposed to work or make sense**

## Installation within parent app

```sh
rake airdata:install:migrations
rake db:migrate
```

## Data stats

* Airports:
* Runways:
* Navaids:
* Waypoints:

## Models and their attributes

### Airports

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

```ruby
attr_accessible :airport_id, :course, :elevation, :glidepath, :ils, :ils_fac
attr_accessible :ils_freq, :lat, :length, :lon, :number

belongs_to :airport
```

* Airport_ID (one-to-many association)
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
