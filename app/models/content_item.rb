# frozen_string_literal: true

class ContentItem < ApplicationRecord
  belongs_to :user
  has_many :publishing_targets, dependent: :destroy
  has_many :social_networks, through: :publishing_targets

  has_rich_text :body

  validates :title, presence: true
  accepts_nested_attributes_for :publishing_targets

  def publishing_targets_attributes=(*attrs)
    self.publishing_targets = []
    super(*attrs)
  end
end
