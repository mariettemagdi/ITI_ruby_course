class ArticlePolicy < ApplicationPolicy
  def index?
      true
  end
  def create?
    puts user.present? && user == record.user
  end
  def edit?
      user == record.user
  end
  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end

  def show?
    !record.archived? || user == record.user
  end

  class Scope < Scope
    def resolve
        scope.where(archived: false).or(scope.where(user: user))
    end
  end
end
