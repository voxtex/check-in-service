class CheckInsApi < Grape::API
  helpers do
    def current_store
      @current_store ||= Store.find(params[:store_id])
    end

    def authorize_store!
      error!(present_error(:invalid_store, 'Invalid store id'), 401) unless current_store
    end
  end
  desc 'Create a check-in'
  params do
    requires :created_at, type: DateTime
    requires :user_id, type: Integer
    requires :hash, type: String
    requires :store_id, type: Integer
  end
  post do
    authorize_store!
    check_in = CheckIn.new(permitted_params)
    valid_hash = check_in.hash == params[:hash].chomp
    error!(present_error(:invalid_hash, 'Hash is invalid.')) unless valid_hash
    check_in.save
    error!(present_error(:record_invalid, check_in.errors.full_messages)) unless check_in.errors.empty?
    represent check_in, with: CheckInRepresenter
  end
end
