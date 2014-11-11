class RedditComment
  include MongoMapper::Document
  key :reddit_id
  key :content
end
