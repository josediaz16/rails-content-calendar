# frozen_string_literal: true

class SocialNetwork < ApplicationRecord
  ALLOWED_NETWORKS = %w[Facebook Instagram Twitter TikTok Pinterest Youtube]
  belongs_to :user
  has_many :publishing_targets, dependent: :destroy
  has_many :content_items, through: :publishing_targets

  validates :description, inclusion: { in: ALLOWED_NETWORKS }

  def self.available_options
    ALLOWED_NETWORKS
  end
end
