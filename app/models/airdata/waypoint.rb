module Airdata
  class Waypoint < ActiveRecord::Base
    attr_accessible :country_code, :elevation, :freq, :ident, :lat, :lon, :name, :range
  end
end
