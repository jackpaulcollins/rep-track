require 'faker'

def load_development_seeds(name)
  ActiveRecord::Base.transaction do
    ActiveRecord::Base.logger.level = :debug # Enable SQL logging
    load(File.join(Rails.root, "db", "seeds", "#{name}.seeds.rb"))
    ActiveRecord::Base.logger.level = :info # Reset logger level after seed execution
  end
end

begin
  load_development_seeds("accounts")
  load_development_seeds("users")
  load_development_seeds("challenges")
  load_development_seeds("reports")
rescue StandardError => e
  puts "An error occurred: #{e.message}"
  puts e.backtrace.join("\n")
end
