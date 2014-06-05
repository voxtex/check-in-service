# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  private_key :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Store < ActiveRecord::Base
  include Napa::FilterByHash

  has_many :check_ins, inverse_of: :store
  validates :name, presence: true

  before_create :generate_private_key

  def check_in(user, timestamp, hash)
    check_ins.create!(user: user, timestamp: timestamp, confirmation_hash: hash)
  end

  def last_check_in_for_user(user)
    check_ins.filter(user: user).order(created_at: :desc).first
  end

  private

  def generate_private_key
    self.private_key ||= SecureRandom.base64(32)
  end
end
