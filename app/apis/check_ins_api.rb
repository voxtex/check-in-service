class CheckInsApi < Grape::API
  resource :check_in do
    desc 'Create a check-in'
    params do
      requires :timestamp, type: Time, desc: 'Time of check-in'
      requires :user_id, type: Integer, desc: 'Id of user checking in'
      requires :confirmation_hash, type: String, desc: 'Values hashed with private key'
      requires :store_id, type: Integer, desc: 'Id of store checking in to'
    end
    post do
      store = Store.find(params[:store_id])
      user = User.find(params[:user_id])
      check_in = store.check_in(user, params[:timestamp], params[:confirmation_hash])
      represent check_in, with: CheckInRepresenter
    end
  end
end
