require "schizo"
require "active_record"
require "pry"

ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => ":memory:")
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.up('spec/db/migrate')

class User < ActiveRecord::Base
  include Schizo::Data
end

class Post < ActiveRecord::Base
  include Schizo::Data
end

RSpec.configure do |config|
  #config.mock_with :rr
end
