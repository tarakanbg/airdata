namespace :airdata do
  desc "Downloads and installs navdata"
  task :setup => :environment do
    puts ""
    puts "Please note this is a VERY LONG task, downloading, validating and"
    puts "injecting nearly 300,000 DB records. Depending on your system and "
    puts "database adapter it might take more than two hours to complete!"
    puts "Stay calm and do not abort the task unless you get any error messages...."
    puts ""
    puts "Processing Airports..."
    Airdata::DataInjector.new("airports")
    puts "Processing Navaids..."
    Airdata::DataInjector.new("navaids")
    puts "Processing Waypoints..."
    Airdata::DataInjector.new("waypoints")
    Rake::Task["rake log:clear"].execute
    puts "All done! Thanks for your patience! Enjoy your newly installed navdata!"
  end

  desc "Truncate navadata tables, populated by Airdata"
  task :truncate => "db:load_config" do
    begin
      config = ActiveRecord::Base.configurations[::Rails.env]
      tables = ["airdata_airports", "airdata_runways", "airdata_waypoints", "airdata_airoptions"]
      ActiveRecord::Base.establish_connection
      puts "Truncating Airdata tables, please wait..."
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
      puts "Airdata tables emptied successfully!"
    end # end of begin
  end # end of task

  desc "Compares your currently installed AIRAC cycle agianst the latest available"
  task :cycle => :environment do
    current = Airdata::DataDownloader.cycle
    latest = Airdata::DataDownloader.latest_cycle
    puts ""
    puts "Currently instaled AIRAC cycle: #{current}"
    puts "Latest available AIRAC cycle: #{latest}"
    if current == latest
      puts ""
      puts "No update is necessary!"
    else
      puts ""
      puts "There's a newer cycle available."
      puts "You can update by running: rake airdata:update"
    end
  end

  desc "Removes old Airdata and installs latest available"
  task :update => :environment do
    Rake::Task["airdata:truncate"].execute
    Rake::Task["airdata:setup"].execute
  end

end # end of namespace
