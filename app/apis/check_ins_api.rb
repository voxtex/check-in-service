class CheckInsApi < Grape::API
  desc 'Create a check-in'
  params do
    requires :timestamp, type: Time, desc: 'Time of check-in'
    requires :user_id, type: Integer, desc: 'Id of user checking in'
    requires :confirmation_hash, type: String, desc: 'Values hashed with private key'
    requires :store_id, type: Integer, desc: 'Id of store checking in to'
  end
  post do
    check_in = store.check_in(user, params[:timestamp], params[:hash])
    represent check_in, with: CheckInRepresenter
  end
end
