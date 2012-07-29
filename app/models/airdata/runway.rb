module Airdata
  class Runway < ActiveRecord::Base
    attr_accessible :airport_id, :course, :elevation, :glidepath, :ils, :ils_fac
    attr_accessible :ils_freq, :lat, :length, :lon, :number

    belongs_to :airport
  end
end
