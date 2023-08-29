class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :teacher, class_name: 'User', foreign_key: :teacher_id
  belongs_to :student, class_name: 'User', foreign_key: :user_id
  belongs_to :program
end
