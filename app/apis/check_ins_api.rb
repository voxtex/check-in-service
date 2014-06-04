class CheckInsApi < Grape::API
  desc 'Get a list of check-ins'
  params do
    optional :ids, type: String, desc: 'comma separated check_in ids'
  end
  get do
    check_ins = CheckIn.filter(permitted_params)
    represent check_ins, with: CheckInRepresenter
  end

  desc 'Create an check-in'
  params do
  end
  post do
    check_in = CheckIn.create(permitted_params)
    error!(present_error(:record_invalid, check_in.errors.full_messages)) unless check_in.errors.empty?
    represent check_in, with: CheckInRepresenter
  end

  params do
    requires :id, desc: 'ID of the check-in'
  end
  route_param :id do
    desc 'Get an check_in'
    get do
      check_in = CheckIn.find(params[:id])
      represent check_in, with: CheckInRepresenter
    end
  end
end
