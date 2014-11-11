class Comment
  include MongoMapper::Document
  key :reddit_id
  key :content
end