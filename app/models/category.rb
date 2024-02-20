# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  priority   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  preferable :boolean          default: false
#
class Category < ApplicationRecord
  PRIORITY_RANGE = 0..10

  enum preferable: { not_preferable: 0, preferable: 1 }

  has_one :price, dependent: :destroy
  has_many :diapers_periods, dependent: :destroy

  has_many :category_categoryables, dependent: :restrict_with_exception
  has_many :categoryables, through: :category_categoryables

  validates :name, presence: true
  validates :name,
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[\p{L}0-9\s'-]+\z/i },
            allow_blank: true
  validates :priority, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered_by_name, -> { order(:name) }
  scope :ordered_by_priority, -> { order(:priority) }
  scope :unsigned_categories, ->(product) { where.not(id: product.categories_by_prices) }

  scope :available_categories, -> { left_outer_joins(:diapers_periods).where(diapers_periods: { category_id: nil }).distinct }
  scope :categories_with_periods, -> { joins(:diapers_periods).distinct }
  scope :unfilled_categories, -> {
                                left_joins(:diapers_periods)
                                  .group(:id)
                                  .having("MAX(diapers_periods.period_end) IS NULL OR MAX(diapers_periods.period_end) < ?", 30)
                              }

  scope :ordered_by_price, -> {
    where.not(id: unfilled_categories)
         .joins(:diapers_periods)
         .group("categories.id")
         .order("MIN(diapers_periods.price) ASC")
  }

  # def self.preferable
  #   find_by(preferable: true)
  # end
end
