class Ability
  include CanCan::Ability

  def initialize(user)
        user ||= User.new # Guest user
        if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can :read, Item
      can :create, Item
      can :update, Item do |item|
        item.try(:user) == user
      end
      can :destroy, Item do |item|
        item.try(:user) == user
      end
    elsif user.regular?
      can :read, Item
    end
      end
end