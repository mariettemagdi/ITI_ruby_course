# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  archived      :boolean          default(FALSE)
#  description   :text
#  reports_count :integer          default(0)
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Article < ApplicationRecord
  belongs_to :user
  has_one_attached:image

  after_commit :check_reports_count, if: :saved_change_to_reports_count?

  private
  def check_reports_count
    if reports_count.to_i >= 3
      update_column(:archived, true) unless archived?
    else
       update_column(:archived, false) if archived?
    end
  end

end
