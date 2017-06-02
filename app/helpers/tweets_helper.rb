# encoding: utf-8
module TweetsHelper

  def default_avatar_url (pol)
    return pol.avatar.url if pol.avatar.url
    if pol.female?
      "/assets/images/avatar_missing_female.png"
    else
      "/assets/images/avatar_missing_male.png"
    end
  end

  def office_title_for (pol)
    pol.office.nil? ? '' : pol.office.title
  end

  def office_abbr_for (pol)
    return nil if pol.office.title.include?('President')
    pol.office.nil? ? '' : pol.office.abbreviation
  end

  def party_name_for (pol)
    pol.party.nil? ? '' : pol.party.name.upcase
  end

  def display_accounts(accounts)
    accounts.map{|acc| link_to(acc.user_name, "http://twitter.com/#{acc.user_name}", target: "_blank") }.join(', ').html_safe
  end

  def format_user_name(tweet_content)
    tweet_content.gsub(/(@(\w+))/, %Q{<a href="http://twitter.com/\\2" target="_blank">\\1</a>})
  end

  def format_hashtag(tweet_content)
    tweet_content.gsub(/(#(\w+))/, %Q{<a href="https://twitter.com/#!/search?q=%23\\2" target="_blank">\\1</a>})
  end

  def format_retweet_prefix (content, user_name)
    "RT @#{user_name}: #{content}"
  end

  def format_tweet(tweet)
    if tweet.retweeted_id.nil?
      content = tweet.content.strip
    else
      content = format_retweet_prefix(tweet.retweeted_content.strip,
                                      tweet.retweeted_user_name)
    end
    content = format_hashtag(content)
    content = format_user_name(content)
    content = auto_link(content, :html => { :target => '_blank' })
  end

  def twitter_url (tweet_user_name, tweet_id)
    "http://www.twitter.com/#{tweet_user_name}/status/#{tweet_id}"
  end

  def tweet_times(tweet)
    if (Time.now - tweet.modified).to_i > (60 * 60 * 24 * 365)
      tweet_time = tweet.modified.strftime("%l:%M %p")
      tweet_date = tweet.modified.strftime("%d %b %y") # 03 Jun 12
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    elsif (Time.now - tweet.modified).to_i > (60 * 60 * 24)
      tweet_time = tweet.modified.strftime("%l:%M %p")
      tweet_date = tweet.modified.strftime("%d %b") # 03 Jun
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    else
      since_tweet = time_ago_in_words tweet.modified
      tweet_when = "<a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{since_tweet}</a> ago"
    end
    [tweet_date, tweet_time, tweet_when]
  end

  def byline(tweet, html = true)
    if (Time.now - tweet.modified).to_i > (60 * 60 * 24 * 365)
      tweet_time = tweet.modified.strftime("%l:%M %p").strip
      tweet_date = tweet.modified.strftime("%d %b %y").strip # 03 Jun 12
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    elsif (Time.now - tweet.modified).to_i > (60 * 60 * 24)
      tweet_time = tweet.modified.strftime("%l:%M %p").strip
      tweet_date = tweet.modified.strftime("%d %b").strip # 03 Jun
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    else
      since_tweet = time_ago_in_words tweet.modified
      tweet_when = "<a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{since_tweet}</a> ago"
    end
    delete_delay = (tweet.modified - tweet.created).to_i

    delay = if delete_delay > (60 * 60 * 24 * 7)
      "after #{pluralize(delete_delay / (60 * 60 * 24 * 7), "week")}"
    elsif delete_delay > (60 * 60 * 24)
      "after #{pluralize(delete_delay / (60 * 60 * 24), "day")}"
    elsif delete_delay > (60 * 60)
      "after #{pluralize(delete_delay / (60 * 60), "hour")}"
    elsif delete_delay > 60
      "after #{pluralize(delete_delay / 60, "minute")}"
    elsif delete_delay > 1
      "after #{pluralize delete_delay, "second"}"
    else
      "immediately"
    end

    if tweet.retweeted_id.nil?
      rt_text = ""
    else
      orig_url = twitter_url(tweet.retweeted_user_name, tweet.retweeted_id)
      rt_text = "<a href=""#{orig_url}"">Original tweet by @#{tweet.retweeted_user_name}</a>."
    end

    if html
      byline = t(:byline,
                  :scope => [:politwoops, :tweets],
                  :retweet => rt_text,
                  :when => tweet_when,
                  :delay => delay).html_safe
      byline += "<div class=""twicon"">#{link_to(svg('Twitter_Logo_Blue'), tweet.twitter_user_url)}</div>".html_safe
      byline += "<div class=""permalink"">#{link_to(svg('link-icon'), tweet.twoops_url)}</div>".html_safe
      byline
    else
      t :byline_text, :scope => [:politwoops, :tweets], :when => tweet_when, :delay => delay
    end
  end

  def rss_date(time)
    time.strftime "%a, %d %b %Y %H:%M:%S %z"
  end

  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    '(not found)'
  end

end
