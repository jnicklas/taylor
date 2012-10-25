require "taylor"
require "active_record"
require "pry"

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
