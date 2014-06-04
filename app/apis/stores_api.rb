class StoresApi < Grape::API
  desc 'Get a list of stores'
  params do
    optional :ids, type: String, desc: 'comma separated store ids'
  end
  get do
    stores = Store.filter(declared(params, include_missing: false))
    represent stores, with: StoreRepresenter
  end

  desc 'Create an store'
  params do
  end

  post do
    store = Store.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, store.errors.full_messages)) unless store.errors.empty?
    represent store, with: StoreRepresenter
  end

  params do
    requires :id, desc: 'ID of the store'
  end
  route_param :id do
    desc 'Get an store'
    get do
      store = Store.find(params[:id])
      represent store, with: StoreRepresenter
    end

    desc 'Update an store'
    params do
    end
    put do
      # fetch store record and update attributes.  exceptions caught in app.rb
      store = Store.find(params[:id])
      store.update_attributes!(declared(params, include_missing: false))
      represent store, with: StoreRepresenter
    end
  end
end
