class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [ Post, Comment ]

    can :manage, :all if user.admin?

    if user.user?
      can :create, [ Post, Comment ]
      can [ :update, :destroy ], [ Post, Comment ], user_id: user.external_user_id
    end
  end
end