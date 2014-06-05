# == Schema Information
#
# Table name: check_ins
#
#  id         :integer          not null, primary key
#  store_id   :integer          not null
#  user_id    :integer          not null
#  timestamp  :datetime
#  created_at :datetime
#  updated_at :datetime
#

class CheckIn < ActiveRecord::Base
  include Napa::FilterByHash

  attr_accessor :confirmation_hash

  belongs_to :store, inverse_of: :check_ins
  belongs_to :user, inverse_of: :check_ins

  validates :store_id, :user_id, :timestamp, presence: true
  validate :timestamp_in_recent_past, on: :create
  validate :matching_hash, on: :create
  validate :rate_limit, on: :create

  # hash the check-in using the stores private key
  def hash
    data = [store.id, user.id, created_at].join('$')
    Base64.encode64(OpenSSL::HMAC.digest('SHA256', store.private_key, data)).chomp
  end

  private

  def matching_hash
    unless confirmation_hash.chomp == hash
      errors.add(:confirmation_hash, 'does not match')
    end
  end

  def timestamp_in_recent_past
    unless (Time.now - timestamp).between?(0, 1.minute)
      errors.add(:created_at, 'is not valid')
    end
  end

  def rate_limit
    last_store_check_in = store.last_check_in_for_user(user)
    if last_store_check_in && (Time.now - last_store_check_in.timestamp) < 1.hour
      errors.add(:base, "Too many check-ins at store #{store.id}")
    end

    last_check_in = user.last_check_in
    if last_check_in && (Time.now - last_check_in.timestamp) < 5.minutes
      errors.add(:base, 'Too many recent check-ins')
    end
  end
end
