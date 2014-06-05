class CheckInRepresenter < Napa::Representer
  property :store, class: Store, decorator: StoreRepresenter
  property :user, class: User, decorator: UserRepresenter
  property :timestamp, type: Time
end