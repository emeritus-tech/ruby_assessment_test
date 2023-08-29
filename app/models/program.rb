class Program < ApplicationRecord
	has_many :enrollments
  	has_many :students, through: :enrollments, source: :student
  	has_many :teachers, through: :enrollments, source: :teacher
end
