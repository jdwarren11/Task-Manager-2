class TM::Employee

  def initialize(name, id=nil)
    @name = name
    @id = id
  end

  def create!
    id_from_db = TM.orm.create_employee(@name)
    @id = id_from_db
    self
  end



end