require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
   sql = <<-SQL
     SELECT *
     FROM students
   SQL

   DB[:conn].execute(sql).map {|student| self.new_from_db(student)}

 end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9

    grade_9 = <<-SQL
      SELECT count (*)
      FROM students
      WHERE grade = 9
      LIMIT 1

    SQL
    DB[:conn].execute(grade_9)

  end

def self.students_below_12th_grade
  grade_12 = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    LIMIT 1

  SQL
  grade_12
  DB[:conn].execute(grade_12)
end


def self.first_X_students_in_grade_10(num)
  number_of_students = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY students.id
    LIMIT ?

  SQL

  DB[:conn].execute(number_of_students, num).map {|student| self.new_from_db(student)}

end



def self.first_student_in_grade_10
  grade_10 = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1
  SQL


student = DB[:conn].execute(grade_10)[0]
self.new_from_db(student)

end


def self.all_students_in_grade_X(grade)
  all_in_grade = <<-SQL
    SELECT *
    FROM students
    LIMIT ?

  SQL

  DB[:conn].execute(all_in_grade, grade)
end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
