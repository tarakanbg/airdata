namespace :airdata do
  desc "Downloads and installs navdata"
  task :setup => :environment do
    puts ""
    puts "Please note this is a VERY LONG task, downloading and injecting"
    puts "nearly 300,000 DB records. Stay calm and do not abort the task"
    puts "unless you get any error messages...."
    puts ""
    puts "Processing Airports..."
    Airdata::DataInjector.new("airports")
    puts "Processing Navaids..."
    Airdata::DataInjector.new("navaids")
    puts "Processing Waypoints..."
    Airdata::DataInjector.new("waypoints")
    puts "All done! Thanks for your patience! Enjoy your newly installed navdata!"
  end
end


namespace :airdata do
  desc "Truncate navadata tables, populated by Airdata"
  task :truncate => "db:load_config" do
    begin
      config = ActiveRecord::Base.configurations[::Rails.env]
      tables = ["airdata_airports", "airdata_runways", "airdata_waypoints"]
      ActiveRecord::Base.establish_connection
      case config["adapter"]
        when "mysql", "postgresql", "mysql2"
          tables.each do |table|
            ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
          end
        when "sqlite", "sqlite3"
          tables.each do |table|
            ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
            ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
          end
          ActiveRecord::Base.connection.execute("VACUUM")
        else
          puts "Ooops... Unable to truncate tables. Unsupported DB adapter."
          puts "You should empty your tables manually."
      end # end of case
    end # end of begin
  end # end of task
end # end of namespace
