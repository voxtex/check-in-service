# == Schema Information
#
# Table name: check_ins
#
#  id         :integer          not null, primary key
#  store_id   :integer          not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class CheckIn < ActiveRecord::Base
  include Napa::FilterByHash

  belongs_to :store, inverse_of: :check_ins
  belongs_to :user, inverse_of: :check_ins

  validates :store, :user, presence: true

  # hash the check-in using the stores private key
  def hash
    data = [store.id, user.id, created_at].join('$')
    Base64.encode64(OpenSSL::HMAC.digest('SHA256', store.private_key, data)).chomp
  end
end
