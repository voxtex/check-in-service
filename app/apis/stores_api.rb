class StoresApi < Grape::API
  resource :store do
    desc 'Get a list of stores'
    get do
      stores = Store.filter(permitted_params)
      represent stores, with: StoreRepresenter
    end

    desc 'Create an store'
    params do
      requires :name, type: String, desc: 'name of the store'
    end
    post do
      store = Store.create!(permitted_params)
      represent store, with: StoreRepresenter
    end

    params do
      requires :id, desc: 'ID of the store'
    end
    route_param :id do
      desc 'Get a store'
      get do
        store = Store.find(params[:id])
        represent store, with: StoreRepresenter
      end

      desc 'Update an store'
      params do
      end
      put do
        store = Store.find(params[:id])
        store.update_attributes!(permitted_params)
        represent store, with: StoreRepresenter
      end
    end
  end
end
