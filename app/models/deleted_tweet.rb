# encoding: utf-8
class DeletedTweet < Tweet
  self.table_name="deleted_tweets"
#default values for approved tweets set by python worker
end
