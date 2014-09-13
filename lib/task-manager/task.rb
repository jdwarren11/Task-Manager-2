
class TM::Task
  attr_reader :id, :pid, :created_at
  attr_accessor :status, :description, :priority

  def initialize(pid, description, priority, id=nil)
    @pid = pid
    @description = description
    @priority = priority
    @created_at = Time.now
    @status = false
    @id = id
  end

  def create!
    id_from_db = TM.orm.create_task(@pid, @priority, @description, @status)
    @id = id_from_db
    self
  end

  def save!
    TM.orm.update_task(@id, @pid, @priority, @description, @status)
  end

  def task_list
    show = TM.orm.show_all_tasks
  end

  def complete!

  end






# ===========================================

  def self.task_list
    @@task_list
  end

  def complete_task
    @status = true
  end

  def self.mark_complete(id)
    task = @@task_list.find { |t| t.tid == id }
    task.complete_task
  end
end
