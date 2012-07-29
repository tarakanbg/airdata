require "airdata/engine"

module Airdata
  class DataDownloader
    %w{curb tempfile tmpdir}.each { |lib| require lib }

    attr_accessor :name, :local, :remote

    def initialize(name)
      @name = name
      @local = "#{Dir.tmpdir}/#{@name}.airdata"
      @remote = "http://cloud.github.com/downloads/tarakanbg/airdata/#{@name}.airdata"
      create_local_file
    end

    private

    def create_local_file
      data = Tempfile.new(@name, :encoding => 'utf-8')
      File.rename data.path, @local
      data = Curl::Easy.perform(@remote).body_str
      File.open(@local, "w+") {|f| f.write(data)}
    end

  end

  class DataInjector
    %w{csv tempfile tmpdir}.each { |lib| require lib }

    attr_accessor :name, :last_ap, :local, :records

    def initialize(name)
      @name = name
      Airdata::DataDownloader.new(@name)
      @local = "#{Dir.tmpdir}/#{@name}.airdata"
      @last_ap = ""
      @records = [];
      process
    end

    private

    def process
      inject_airports if @name == "airports"
      inject_navaids if @name == "navaids"
      inject_waypoints if @name == "waypoints"
      cleanup
    end

    def inject_airports
      # delete_old_records
      CSV.foreach(@local, :col_sep =>',') do |row|
        type = row[0]
        if type == "A"
          ap = Airdata::Airport.create!(:icao => row[1], :name => row[2], :lat => row[3],
                 :lon => row[4], :elevation => row[5], :ta => row[6], :msa => row[8] )
          @last_ap = ap.id
        elsif type == "R"
          # Airdata::Runway.create!(:airport_id => @last_ap, :course => row[2], :elevation => row[10],
          #   :glidepath => row[11], :ils => row[5], :ils_fac => row[7], :ils_freq => row[6],
          #   :lat => row[8], :lon => row[9], :length => row[3], :number => row[1])
          @records << Airdata::Runway.new(:airport_id => @last_ap, :course => row[2], :elevation => row[10],
            :glidepath => row[11], :ils => row[5], :ils_fac => row[7], :ils_freq => row[6],
            :lat => row[8], :lon => row[9], :length => row[3], :number => row[1])
        end # end if
      end  # end CSV loop
      Airdata::Runway.import @records
    end # end method

    def inject_navaids
      # Airdata::Waypoint.destroy_all
      # Airdata::Waypoint.delete_all
      CSV.foreach(@local, :col_sep =>',') do |row|
        @records << Airdata::Waypoint.new(:ident => row[0], :name => row[1], :freq => row[2],
          :range => row[5], :lat => row[6], :lon => row[7], :elevation => row[8], :country_code => row[9])
      end
      Airdata::Waypoint.import @records
    end

    def inject_waypoints
      CSV.foreach(@local, :col_sep =>',') do |row|
        @records << Airdata::Waypoint.new(:ident => row[0], :lat => row[1], :lon => row[2], :country_code => row[3])
      end
      Airdata::Waypoint.import @records
    end

    def cleanup
      File.delete(@local)
    end

    def delete_old_records
      # Airdata::Airport.destroy_all
      # Airdata::Runway.destroy_all
      # Airdata::Airport.delete_all
      # Airdata::Runway.delete_all
    end

  end

end
