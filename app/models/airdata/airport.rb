module Airdata
  class Airport < ActiveRecord::Base
    attr_accessible :elevation, :icao, :lat, :lon, :msa, :name, :ta

    has_many :runways, :dependent => :destroy
  end
end
