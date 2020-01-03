class Dog 
   attr_accessor :name, :breed
attr_reader :id
 
  def initialize(attributes)
    @id = id
    @name = name
    @breed = breed
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
  
   def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    student = self.new(row[0], row[1], row[2])
    student
  end
  
  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


  
  
  
end