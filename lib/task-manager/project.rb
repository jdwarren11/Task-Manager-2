
class TM::Project
  attr_reader :id 
  attr_accessor :name

  def initialize(name, id=nil)
    @name = name
    @id = id
  end

  def create!
    id_from_db = TM.orm.create_project(@name)
    @id = id_from_db
    self
  end

  def save!
    TM.orm.update_project(@name, @id)
  end

  def project_list
    show = TM.orm.show_all_projects
  end

  def project_by_id
    TM.orm.get_project_by_id(@id)
  end

  def get_complete_tasks
    complete = TM.orm.show_all_tasks.select do |t|
      t.pid == self.pid && t.status == true
    end

    complete.sort_by { |t| t.created_at }
  end

  def get_incomplete_tasks
    incomplete = TM.orm.show_all_tasks.select do |t|
      t.pid == self.pid && t.status == false
    end

    incomplete.sort_by { |t| [t.priority, t.created_at] }
  end

end
