class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= Customer.new # guest user (not logged in)
      can :read, :all
      if user.is_a?(Admin)
        can :manage, :all
        can :access, :rails_admin   # grant access to rails_admin
        can :dashboard              # grant access to the dashboard
      end
  end
end
