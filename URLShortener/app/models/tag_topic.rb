# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  topic      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagTopic < ActiveRecord::Base
  validates :topic, presence: true, uniqueness: true

  has_many :taggings,
    foreign_key: :tag_topic_id,
    primary_key: :id,
    class_name: "Tagging"

  has_many :tagged_urls,
    through: :taggings,
    source: :tagged_url

  has_many :users_sub_topic,
    through: :tagged_urls,
    source: :submitter

end
