# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishingTarget, type: :model do
  describe 'validations' do
    context 'publishing_date' do
      let(:user) { FactoryBot.create(:user) }
      let(:content_item) { FactoryBot.create(:content_item, user: user) }
      let(:social_network) { FactoryBot.create(:social_network, user: user) }

      subject { described_class.new(content_item: content_item, social_network: social_network) }

      it 'is not valid when publishing_date is not present' do
        subject.publishing_date = nil

        expect(subject.valid?).to eq(false)
        expect(subject.errors.messages).to eq({ publishing_date: ["can't be blank"] })
      end

      it 'is not valid when publishing_date is in the past' do
        subject.publishing_date = 3.minutes.ago

        expect(subject.valid?).to eq(false)
        expect(subject.errors.messages).to eq({ publishing_date: ["cannot be a date in the past or the current minute"] })
      end

      it 'is not valid when publishing_date is in the current minute' do
        subject.publishing_date = 30.seconds.from_now

        expect(subject.valid?).to eq(false)
        expect(subject.errors.messages).to eq({ publishing_date: ["cannot be a date in the past or the current minute"] })
      end

      it 'is valid when publishing_date is after the current minute' do
        subject.publishing_date = 70.seconds.from_now

        expect(subject.valid?).to eq(true)
      end
    end
  end
end
