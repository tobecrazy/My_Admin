class Report < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[comments created_at id item_name row_index start_date status updated_at]
  end
end
