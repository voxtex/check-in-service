class UsersApi < Grape::API
  desc 'Get a list of users'
  get do
    users = User.filter(permitted_params)
    represent users, with: UserRepresenter
  end

  desc 'Create an user'
  params do
    requires :username, type: String, desc: 'Username for new user.'
  end
  post do
    user = User.create(permitted_params)
    error!(present_error(:record_invalid, user.errors.full_messages)) unless user.errors.empty?
    represent user, with: UserRepresenter
  end

  params do
    requires :id, desc: 'ID of the user'
  end
  route_param :id do
    desc 'Get a user'
    get do
      user = User.find(params[:id])
      represent user, with: UserRepresenter
    end
  end
end
