module UsersHelper
  def favorite_teachers(user)
    teacher_ids = Enrollment.where(user: user, favorite: true).distinct.pluck(:teacher_id)
    User.where(id: teacher_ids).uniq.pluck(:name).join(', ')
  end

  def classmates(user)
    teacher_ids = Enrollment.where(user: user).distinct.pluck(:teacher_id)
    enrolled_user_ids_with_teacher = Enrollment.where(teacher_id: teacher_ids).distinct.pluck(:user_id)
    User.where(id: enrolled_user_ids_with_teacher).where.not(id: user.id).map(&:name).join(', ')
  end
end
