require "schizo"
require "active_record"
require "pry"

ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))

class User < ActiveRecord::Base
  include Schizo::Data
end

class Post < ActiveRecord::Base
  include Schizo::Data
end

RSpec.configure do |config|
  #config.mock_with :rr
end
