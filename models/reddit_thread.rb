class RedditThread
  include MongoMapper::Document
  key :reddit_id
  key :content
end