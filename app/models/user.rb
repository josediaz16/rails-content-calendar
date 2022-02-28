# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :content_items, dependent: :destroy
  has_many :social_networks, dependent: :destroy
  has_many :publishing_targets, through: :content_items
end
