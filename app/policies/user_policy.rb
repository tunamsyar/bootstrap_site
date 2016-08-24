class UserPolicy < ApplicationPolicy

  def edit?
    user.present? && record.user == user
  end

  def update?
    edit?
  end
