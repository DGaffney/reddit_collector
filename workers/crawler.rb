class Crawler
  include Sidekiq::Worker
  def url
    "http://www.reddit.com/r/KotakuInAction/"
  end

  def crawl_format
    ".json"
  end

  def perform
    data = JSON.parse(RestClient.get(url+crawl_format+"?count=100"))
    while !data.data.after.nil?
      data.data.children.collect(&:data).each do |thread|
        t = RedditThread.first_or_create(reddit_id: thread.id)
        t.content = thread
        t.save!
        CollectThread.perform_async(thread.id)
      end
      data = JSON.parse(RestClient.get(url+crawl_format+"?count=100&after="+data.data.after))
    end
  end
end
