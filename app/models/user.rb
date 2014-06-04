# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  include Napa::FilterByHash

  validates :username, presence: true
  has_many :check_ins, inverse_of: :user
end
