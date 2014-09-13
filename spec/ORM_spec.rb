require 'spec_helper.rb'
require 'pry-byebug'

describe 'ORM' do
  describe 'db as a singleton' do 
    it 'returns a db object' do 
      db = TM.orm
      expect(db).to be_a(ORM)
    end

    it 'returns the same db object every time' do
      db = TM.orm
      db2 = TM.orm
      expect(db).to be(db2)
    end
  end
end