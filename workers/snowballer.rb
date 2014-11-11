class Snowballer
  include Sidekiq::Worker
  def url(query)
    "http://www.reddit.com/r/KotakuInAction/search.json?q=#{query}&restrict_sr=on&sort=relevance&t=all"
  end

  def perform(query)
    count = 100
    data = JSON.parse(RestClient.get(url(query)))
    while !data.data.after.nil?
      count += 100
      data.data.children.collect(&:data).each do |thread|
        if RedditThread.first(reddit_id: thread.id).nil?
          t = RedditThread.first_or_create(reddit_id: thread.id)
          t.content = thread
          t.save!
          CollectThread.perform_async(thread.id)
        end
      end
      data = JSON.parse(RestClient.get(url(query)+"&count=#{count}&after="+data.data.after))
    end
  end
end