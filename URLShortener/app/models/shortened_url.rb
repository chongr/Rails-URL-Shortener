# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :string
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :long_url, presence: true
  validates_length_of :long_url, maximum: 1024
  validates :post_by_user_within_time, numericality: {less_than: 5}

  belongs_to :submitter,
  foreign_key: :user_id,
  primary_key: :id,
  class_name: 'User'

  has_many :visits,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: 'Visit'

  has_many :visitors,
  Proc.new { distinct },
  through: :visits,
  source: :user

  has_many :taggings,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: "Tagging"

  has_many :tag_topics,
    through: :taggings,
    source: :tagged_topic

  def self.random_code
    r_code = SecureRandom.urlsafe_base64

    while exists?(short_url: r_code)
      r_code = SecureRandom.urlsafe_base64
    end

    r_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: random_code)
  end


  def num_clicks
    visits.count
  end

  def num_uniques
    # visits.select(:user_id).distinct.count
    visitors
  end

  def num_recent_uniques
    visits.select(:user_id).where("updated_at > ?", 10.minutes.ago).distinct.count
  end

  def post_by_user_within_time
    ShortenedUrl.where("updated_at > ? AND user_id = ?", 1.minutes.ago, user_id).count
  end

end
