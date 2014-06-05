class CheckInRepresenter < Napa::Representer
  property :store, class: Store, decorator: StoreRepresenter
  property :user, class: User, decorator: UserRepresenter
end