# encoding: utf-8
class Tweet < ActiveRecord::Base
  belongs_to :politician

  has_many :tweet_images, :foreign_key => "tweet_id"

  scope :with_content, -> { where.not content: nil}
  scope :retweets, -> { where.not retweeted_id: nil}

  before_save :extract_retweet_fields

  def self.in_order
    includes(:politician).order('modified DESC')
  end

  def self.latest
    order('created DESC')
  end

  def self.deleted
    where(deleted: 1).where.not(content: nil)
  end

  def self.in_year(year)
    where("created >= #{Date.new(year, 1, 1)}").where("created <= #{Date.new(year, 12, 31)}")
  end

  def self.random
    Tweet.find(Tweet.pluck(:id).shuffle.first)
  end


  def self.published_in(year, month)
    where("YEAR(created) = #{year} AND MONTH(created) = #{month}")
  end

  def self.modified_in(year, month)
    where("YEAR(modified) = #{year} AND MONTH(modified) = #{month}")
  end
  
  def details
    JSON.parse(tweet)
  end

  def extract_retweeted_status
    return nil if tweet.nil?
    orig_obj = JSON::parse(tweet) rescue nil
    return nil if orig_obj.nil?
    return nil if not orig_obj.is_a?(Hash)
    return nil if orig_obj["retweeted_status"].nil?

    return orig_obj["retweeted_status"]
  end

  def extract_retweet_fields (options = {})
    if retweeted_id.nil? || !options[:overwrite].nil?
      orig_hash = extract_retweeted_status
      if orig_hash
        self.retweeted_id = orig_hash["id"]
        self.retweeted_content = orig_hash["text"]
        self.retweeted_user_name = orig_hash["user"]["screen_name"]
      end
    end
  end

  def twoops_url
    "/tweet/#{id}"
  end

  def twitter_user_url
    "https://www.twitter.com/#{user_name}"
  end

  def twitter_url
    "https://www.twitter.com/#{user_name}/status/#{id}"
  end
  
  def has_images?
    not self.tweet_images.empty?
  end

  def format
    {
      :created_at => created,
      :updated_at => modified,
      :id => (id and id.to_s),
      :politician_id => politician_id,
      :details => details,
      :content => content,
      :user_name => user_name
    }
  end
end
