class TM::TerminalClient

  def self.run
    puts "Welcome to Project Manager Pro."
    user_input = gets.chomp
    splitted = user_input.split

    cmd = splitted.first.downcase

    parse(cmd, splitted)
  end

  def self.parse(cmd, splitted)
    case cmd
    when "add"
      add_cmd(splitted[1..-1])

    when "create"
      create_cmd(splitted[1..-1])

    when "mark"
      mark_cmd(splitted[1..-1])

    when "history"
      history_cmd(splitted[1..-1])

    when "show"
      show_cmd(splitted[1..-1])

    when "list"
      TM::Project.project_list.each do |p|
        puts "Project Name: #{p.name}"
        puts "Project ID: #{p.pid}"
        puts "-----------------------"
      end
    when "help"
      puts "list - list all projects"
      puts "create NAME - Create a new project with name=NAME"
      puts "show PID - Show remaining tasks for project with id=PID"
      puts "history PID - Show completed tasks for project with id=PID"
      puts "add PID PRIORITY DESC - Add a new task to project with id=PID"
      puts "mark TID - Mark task with id=TID as complete"
      puts "exit - Exit Task Manager"
    when "exit"
      return
    else
      "not a command"
    end
    run
  end

  def self.add_cmd(input_array)
    # parse array 
    pid = input_array.first.to_i
    pri = input_array[1].to_i
    desc = input_array[2..-1].join(" ")

    TM::Task.new(pid, desc, pri)
  end

  def self.create_cmd(name_arr)
    name = name_arr[0..-1].join(" ")
    TM::Project.new(name)
    puts "Project #{name} was created."
  end

  def self.mark_cmd(tid_arr)
    tid = tid_arr[0].to_i
    TM::Task.mark_complete(tid)
  end

  def self.show_cmd(pid_arr)
    pid = pid_arr[0].to_i
    proj = TM::Project.project_list.find { |p| p.pid == pid }
    tasks = proj.get_incomplete_tasks
    tasks.each do |x|
      puts "Priority: #{x.priority} | Task ID: #{x.tid} | Description: #{x.description}"
    end
  end

  def self.history_cmd(pid_arr)
    pid = pid_arr[0].to_i
    proj = TM::Project.project_list.find { |p| p.pid == pid }
    tasks = proj.get_complete_tasks 
    tasks.each do |x|
      puts "Task ID: #{x.tid} | Description: #{x.description}"
    end
  end

end


















