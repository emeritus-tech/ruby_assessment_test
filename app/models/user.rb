class User < ApplicationRecord
    has_many :student_enrollments, foreign_key: :user_id, class_name: 'Enrollment'
    has_many :teacher_enrollments, foreign_key: :teacher_id, class_name: 'Enrollment'
    has_many :favorite_teachers, through: :student_enrollments, source: :teacher, class_name: 'User'
  
    enum kind: {
      student: 0,
      teacher: 1,
      student_teacher: 2
    }
  
    before_update :prevent_role_change_with_programs
  
    def prevent_role_change_with_programs
        if self.kind_changed? && (student_enrollments.exists? || teacher_enrollments.exists?) && (self.kind == "teacher" || self.kind == "student")
            errors.add(:base, "Kind can not be #{self.kind} because is teaching in at least one program") if self.kind == "student" 
            errors.add(:base, "Kind can not be #{self.kind} because is studying in at least one program") if self.kind == "teacher" 
            throw :abort
        end
    end
  
    def self.classmates(user)
      teacher_ids = Enrollment.where(user: user).distinct.pluck(:teacher_id)
      enrolled_user_ids_with_teacher = Enrollment.where(teacher_id: teacher_ids).distinct.pluck(:user_id)
      where(id: enrolled_user_ids_with_teacher).where.not(id: user.id)
    end
  
    def self.get_fav_teacher(user)
      teacher_ids = Enrollment.where(user: user, favorite: true).distinct.pluck(:teacher_id)
      where(id: teacher_ids)
    end
end
  