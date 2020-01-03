class Dog 
   attr_accessor :name, :breed, :id
 
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end
 
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end
 
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.breed)

        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      end
  end
 
  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end
 
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
  end
  
   def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ? AND breed = ?
      SQL


      dog = DB[:conn].execute(sql, name, breed).first

      if dog
        new_dog = self.new_from_db(dog)
      else
        new_dog = self.create({:name => name, :breed => breed})
      end
      new_dog
  end
  
   def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    dog = self.new(row[0], row[1], row[2])
    dog
  end
  
  def update
    sql = <<-SQL
      UPDATE dog
      SET name = ?, breed = ?
      WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.breed, self.id)
  end


  
  
  
end