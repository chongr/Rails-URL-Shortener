# == Schema Information
#
# Table name: taggings
#
#  id               :integer          not null, primary key
#  shortened_url_id :integer          not null
#  tag_topic_id     :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Tagging < ActiveRecord::Base
  validates :shortened_url_id, presence: true
  validates :tag_topic_id, presence: true

  belongs_to :tagged_url,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: "ShortenedUrl"

  belongs_to :tagged_topic,
    foreign_key: :tag_topic_id,
    primary_key: :id,
    class_name: "TagTopic"
end
