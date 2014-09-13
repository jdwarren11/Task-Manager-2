require 'spec_helper'
require 'pry-byebug'

describe 'Task' do
  before(:each) do 
    TM::Project.class_variable_set :@@pcounter, 0
    TM::Task.class_variable_set :@@task_list, []
    TM::Task.class_variable_set :@@tcounter, 0
  end
  
  it "exists" do
    expect(TM::Task).to be_a(Class)
  end

  it "can create new task" do
    task = TM::Task.new(1, "this is task 1", 1)
    expect(task.pid).to eq(1)
    expect(task.description).to eq("this is task 1")
    expect(task.priority).to eq(1) 
  end

  it "can complete a task" do 
    task = TM::Task.new(1, "this is task 1", 1)
    expect(task.status).to eq(false)
    task.complete_task
    expect(task.status).to eq(true)
  end
end
