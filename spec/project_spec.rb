require 'spec_helper'
require 'pry-byebug'

describe 'Project' do
  before(:each) do 
    TM::Project.class_variable_set :@@pcounter, 0
    TM::Task.class_variable_set :@@task_list, []
    TM::Task.class_variable_set :@@tcounter, 0

    @project = TM::Project.new("Science")
    (0..2).each { |i| TM::Task.new(0, "blah", i+50) }
  end

  it "exists" do
    expect(TM::Project).to be_a(Class)
  end

  it "must have a name" do
    expect(@project.name).to eq("Science")
  end

  it "has a project id" do
    expect(@project.pid).to eq(0)
  end

  it "can get a list of incomplete tasks" do
    inc_tasks = @project.get_incomplete_tasks
    expect(inc_tasks.size).to eq(3)
  end

  it "can get a list of complete tasks" do
    TM::Task.mark_complete(0)
    TM::Task.mark_complete(1)
    comp_tasks = @project.get_complete_tasks 
    expect(comp_tasks.size).to eq(2)
  end

  it "can get a list of complete tasks sorted by completion" do
    TM::Task.mark_complete(1)
    TM::Task.mark_complete(0)
    comp_tasks = @project.get_complete_tasks
    expect(comp_tasks.first.created_at).should be < comp_tasks.last.created_at
  end

  it "can get a list of incomplete tasks sorted by priority, then creation" do
    inc_tasks = @project.get_incomplete_tasks
    expect(inc_tasks.first.priority).should be < inc_tasks.last.priority
  end

end
