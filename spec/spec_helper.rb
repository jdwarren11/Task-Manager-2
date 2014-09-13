# Require our project, which in turns requires everything else
require './lib/task-manager.rb'
require './lib/task-manager/project.rb'
require './lib/task-manager/task.rb'
require './lib/ORM.rb'

Rspec.configure do |config|
  config.before(:each) do
    TM.instance_variable_set(:@__db_instance, nil)
  end
end