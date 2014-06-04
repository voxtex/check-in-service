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

  validates :name, :private_key, presence: true
  has_many :check_ins, inverse_of: :store
end
