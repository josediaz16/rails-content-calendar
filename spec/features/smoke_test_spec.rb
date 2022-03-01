# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SmokeTests', type: :feature do
  before do
    allow(Time)
      .to receive(:now)
      .and_return(Time.new(2022, 2, 25))
  end

  it 'base content creation', js: true do
    user = create :user

    sign_in user
    visit root_path

    # Add social network
    click_on 'Social Networks'
    click_on 'Add social network'
    fill_in 'Description', with: "Facebook"

    click_on 'Create Social network'
    expect(page).to have_content("Facebook added")

    # Add content
    click_on 'Content Items'
    click_on 'Add Content item'

    fill_in 'Title', with: 'My Title'

    fill_in_rich_text_area 'Body', with: 'My body'

    click_on 'Create Content item'
    expect(page).to have_content('My Title added')

    # View Content
    within '#content-items' do
      click_on 'My Title'
    end
    expect(page).to have_content('My body')

    # add social network
    click_on 'Edit'

    check "Facebook"
    select '2022', from: 'content_item[publishing_targets_attributes][0][publishing_date][year]'
    select 'March', from: 'content_item[publishing_targets_attributes][0][publishing_date][month]'
    select '1', from: 'content_item[publishing_targets_attributes][0][publishing_date][day]'
    select '20', from: 'content_item[publishing_targets_attributes][0][publishing_date][hour]'
    select '10', from: 'content_item[publishing_targets_attributes][0][publishing_date][minute]'

    click_on 'Update Content item'
    expect(page).to have_content('My Title updated')

    # Create new event
    content_item = FactoryBot.create(:content_item, user: user, title: 'Show your skills')
    social_network = FactoryBot.create(:social_network, user: user)
    FactoryBot.create(:publishing_target, content_item: content_item, social_network: social_network, publishing_date: 3.days.from_now)

    visit content_items_path
    expect(page.all('td.has-events').count).to eq(2)

    within 'td.has-events .at-2022-03-02' do
      expect(page).to have_content('2022-03-02')
      expect(page).to have_content('My Title')
    end

    within 'td.has-events .at-2022-02-28' do
      expect(page).to have_content('2022-02-28')
      expect(page).to have_content(content_item.title)
    end

    # Search Form
    fill_in 'text', with: 'Title'
    click_on 'Search'

    expect(page.all('td.has-events').count).to eq(1)

    within '.simple-calendar' do
      expect(page).not_to have_content(content_item.title)
      expect(page).to have_content('My Title')
    end

    within '#content-items' do
      click_on 'My Title'
    end

    expect(page).to have_content("Facebook")
    expect(page).to have_content("2022-03-02 01:10:00 UTC")

    # delete content
    accept_confirm do
      click_on 'Delete'
    end

    expect(page).to have_content('My Title deleted')
    expect(page).not_to have_link('My Title')
  end
end
