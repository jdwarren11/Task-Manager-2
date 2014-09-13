require 'pry-byebug'
require 'pg'

module TM
  class ORM

    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'task-manager2')
      build_tables
    end

    def build_tables
      @db.exec(%Q[
        CREATE TABLE IF NOT EXISTS projects(
          id serial NOT NULL PRIMARY KEY,
          NAME VARCHAR(30)
          )])

      @db.exec(%Q[
        CREATE TABLE IF NOT EXISTS tasks(
          id serial NOT NULL PRIMARY KEY,
          project_id integer REFERENCES projects(id),
          priority integer,
          description text,
          status boolean,
          created_at timestamp NOT NULL DEFAULT current_timestamp
          )])

      @db.exec(%Q[
        CREATE TABLE IF NOT EXISTS employees(
          id serial NOT NULL PRIMARY KEY,
          NAME VARCHAR(30)
          )])
    end

# ============================================================
#         START PROJECTS
# ============================================================

    def create_project(name)
      response = @db.exec_params(%Q[
      INSERT INTO projects(name)
      VALUES ($1)
      RETURNING id;
      ], [name])

      response.first["id"]
    end

    def update_project(data)
      id = data["id"]
      name = data["name"]
      response = @db.exec_params(%Q[
        UPDATE projects
        SET (name) = ($1)
        WHERE id = $2;
        ], [name, id])
      data = response.first
      # TM::Project.new(data)
      build_project(data)
    end

    def build_project(data)
    end

    def delete_project(id)
      @db.exec(%Q[
        DELETE FROM projects WHERE id = #{id};
        ])
    end

    def get_project_by_id(id)
      project = @db.exec_params(%Q[
        SELECT * FROM projects WHERE id = $1;
        ],[id])
      data = project.first
      TM::Project.new(data)
    end

    def show_all_projects
      list = @db.exec(%Q[
        SELECT * FROM projects;
        ])
      list.map { |r| TM::Project.new(r["name"], r["id"]) }
    end

# ============================================================
#         END PROJECTS
#         START TASKS
# ============================================================

    def create_task(data)
      pid = data["project_id"]
      priority = data["priority"]
      description = data["description"]
      status = false

      response = @db.exec_params(%Q[
        INSERT INTO tasks(project_id, priority, description, status)
        VALUES ($1, $2, $3, $4)
        RETURNING id;
        ], [pid, priority, description, status])

      response.first["id"]
    end

    def get_task(id)
      task = @db.exec_params(%Q[
        SELECT * FROM tasks WHERE id = $1;
        ], [id])
      data = task.first
      TM::Task.new(data)
    end
# get rid of hash and interpolate
    def update_task(id, pid, priority, description, status)
      x = []
      data.each_pair do|k, v|
        x << "#{k} = #{v}"
      end

      str = x.join(",")

      command = @db.exec(%Q[
        UPDATE tasks
        SET #{str}
        WHERE id = #{data["id"]};
        ])
      TM::Task.new(command)
    end

    def delete_task(id)
      @db.exec(%Q[
        DELETE FROM tasks WHERE id = #{id};
        ])
    end

    def show_all_tasks
      list = @db.exec(%Q[
        SELECT * FROM tasks;
        ])
      list.map { |r| TM::Task.new(r["id"], r["project_id"], r["priority"], 
        r["description"], r["status"], r["created_at"]) }
    end
    # ============================================================
    #         END TASKS
    #         START EMPLOYEES
    # ============================================================
    def create_employee(name)
      response = @db.exec_params(%Q[
      INSERT INTO employees(name)
      VALUES ($1)
      RETURNING id;
      ], [name])

      response.first["id"]
    end


  end

  def self.orm
    @__db_instance ||= ORM.new
  end
end