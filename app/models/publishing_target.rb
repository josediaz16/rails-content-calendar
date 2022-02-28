# frozen_string_literal: true

class PublishingTarget < ApplicationRecord
  belongs_to :content_item
  belongs_to :social_network

  validates :publishing_date, presence: true
  validate :valid_publishing_date, if: -> { publishing_date? }

  def valid_publishing_date
    if publishing_date < 1.minutes.from_now
      errors.add(:publishing_date, 'cannot be a date in the past or the current minute')
    end
  end
end
