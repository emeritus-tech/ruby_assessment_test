class User < ApplicationRecord

  has_many :enrollments_as_student, foreign_key: :user_id, class_name: 'Enrollment'
  has_many :enrollments_as_teacher, foreign_key: :teacher_id, class_name: 'Enrollment'

  has_many :favorite_teachers, through: :enrollments_as_student, source: :teacher, class_name: 'User'


  enum kind: {
    student: 0,
    teacher: 1,
    student_teacher: 2
  }

  before_update :ensure_role_change_allowed

  def ensure_role_change_allowed
    if self.kind_changed? && (enrollments_as_student.exists? || enrollments_as_teacher.exists?) && (self.kind == "teacher" || self.kind == "student")
      errors.add(:base, "Kind can not be #{self.kind} because is teaching in at least one program") if self.kind == "student" 
      errors.add(:base, "Kind can not be #{self.kind} because is studying in at least one program") if self.kind == "teacher" 
      throw :abort
    end
  end


  def self.classmates(user)
      teacher_ids = Enrollment.where(user_id:user.id).pluck(:teacher_id).uniq
      enrolled_user_ids_with_teacher = Enrollment.where(teacher_id:teacher_ids).pluck(:user_id).uniq
      User.where(id: enrolled_user_ids_with_teacher).where.not(id: user.id)
  end

  def self.get_fav_teacher(user)
      teacher_ids = Enrollment.where(user_id:user.id, favorite:true).pluck(:teacher_id).uniq
      User.where(id: teacher_ids)
  end

  
end
