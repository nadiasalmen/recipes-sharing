# frozen_string_literal: true
class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, :description, :ingredients, :steps, presence: true
  validates :title, length: { minimum: 5 }
  validates :description, length: { minimum: 20 }
  validate :image_format_and_size

  def image_url
    image.attached? ? image.url : :nil
  end

  private

  def image_format_and_size
    return unless image.attached?

    errors.add(:image, 'is missing') unless image.attached?
    errors.add(:image, 'is not an image') unless image.content_type.in?(%('image/jpeg image/png'))
    errors.add(:image, 'is too big') if image.byte_size > 5.megabytes
  end
end
