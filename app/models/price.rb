# frozen_string_literal: true

# == Schema Information
#
# Table name: prices
#
#  id             :bigint           not null, primary key
#  priceable_type :string
#  sum            :decimal(8, 2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :integer
#  priceable_id   :bigint
#
# Indexes
#
#  index_prices_on_category_id  (category_id)
#  index_prices_on_priceable    (priceable_type,priceable_id)
#
class Price < ApplicationRecord
  belongs_to :priceable, polymorphic: true
  belongs_to :category, optional: true

  validates :sum, presence: true
  validates :priceable_id,
            uniqueness: { scope: [:category_id, :priceable_type] }
end
