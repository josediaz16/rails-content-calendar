class AddPublishingDateToPublishingTarget < ActiveRecord::Migration[6.1]
  def change
    add_column :publishing_targets, :publishing_date, :datetime
  end
end
