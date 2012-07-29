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

    def create_local_file
      data = Tempfile.new(@name, :encoding => 'utf-8')
      File.rename data.path, @local
      data = Curl::Easy.perform(@remote).body_str
      File.open(@local, "w+") {|f| f.write(data)}
    end


  end

  class DataInjector
    %w{csv tempfile tmpdir}.each { |lib| require lib }

    attr_accessor :name, :last_ap, :local

    def initialize(name)
      @name = name
      Airdata::DataDownloader.new(@name)
      @local = "#{Dir.tmpdir}/#{@name}.airdata"
      @last_ap = ""
      process
    end

    def process
      inject_airports if @name == "airports"
    end

    def inject_airports
      Airdata::Airport.destroy_all
      Airdata::Runway.destroy_all
      CSV.foreach(@local, :col_sep =>',') do |row|
        type = row[0].to_s
        if type == "A"

          icao, name, lat, lon, elevation, ta, msa = row[1].to_s, row[2].to_s, row[3].to_s, row[4].to_s, row[5].to_s, row[6].to_s, row[8].to_s
          ap = Airdata::Airport.create!(:icao => icao, :name => name, :lat => lat, :lon => lon,
                                   :elevation => elevation, :ta => ta, :msa => msa )
          @last_ap = ap.id

        elsif type == "R"

          number, course, length, ils = row[1].to_s, row[2].to_s, row[3].to_s, row[5].to_s
          ils_freq, ils_fac, lat, lon = row[6].to_s, row[7].to_s, row[8].to_s, row[9].to_s
          elevation, glidepath = row[10].to_s, row[11].to_s

          Airdata::Runway.create!(:airport_id => @last_ap, :course => course, :elevation => elevation,
            :glidepath => glidepath, :ils => ils, :ils_fac => ils_fac, :ils_freq => ils_freq,
            :lat => lat, :lon => lon, :length => length, :number => number)
        end
      end
    end


  end

  class DataProcessor
  end
end
