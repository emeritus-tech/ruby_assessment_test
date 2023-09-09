class User < ApplicationRecord
    has_many :student_enrollments, foreign_key: :user_id, class_name: 'Enrollment'
    has_many :teacher_enrollments, foreign_key: :teacher_id, class_name: 'Enrollment'
    has_many :teachers, through: :student_enrollments, source: :teacher, class_name: 'User'
    before_update :prevent_role_change_with_programs


    enum kind: {
      student: 0,
      teacher: 1,
      student_teacher: 2
    }

    def prevent_role_change_with_programs
        if (student_enrollments.exists? || teacher_enrollments.exists?) && (kind == "teacher" || kind == "student")
            errors.add(:base, "Kind can not be #{kind} because is teaching in at least one program") if kind == "student"
            errors.add(:base, "Kind can not be #{kind} because is studying in at least one program") if kind == "teacher"
            throw :abort
        end
    end
end
