require 'oj'
class CollectThread
  include Sidekiq::Worker
  def url
    "http://www.reddit.com/r/KotakuInAction/comments/"
  end

  def crawl_format
    ".json"
  end

  def store_children(comment)
    replies = comment.replies.data.children rescue []
    comment.delete("replies")
    c = RedditComment.first_or_create(reddit_id: comment.id)
    c.content = comment
    c.save!
    replies.each do |reply|
      store_children(reply)
    end
  end

  def perform(thread_id)
    data = Oj.load(RestClient.get(url+thread_id+crawl_format))
    post = data.first.data.children.first.data
    data.last.data.children.collect(&:data).each do |comment|
      store_children(comment)
    end
  end
end