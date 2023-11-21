# frozen_string_literal: true
class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, :description, :image, :ingredients, :steps, presence: true
  validates :title, length: { minimum: 5 }
  validates :description, length: { minimum: 20 }
  validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates :image, size: { less_than: 5.megabytes }
end
