require "faker"

def load_development_seeds(name)
  ActiveRecord::Base.transaction do
    load(File.join(Rails.root, "db", "seeds", "#{name}.seeds.rb"))
  end
end

begin
  ActiveRecord::Base.logger = Logger.new($stdout)
  load_development_seeds("accounts")
  load_development_seeds("users")
  load_development_seeds("challenges")
  load_development_seeds("reports")
rescue => e
  puts "An error occurred: #{e.message}"
  puts e.backtrace.join("\n")
ensure
  ActiveRecord::Base.logger = nil
end
