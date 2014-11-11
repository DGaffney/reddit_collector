class SnowballTerms
  include Sidekiq::Worker
  def terms
    RedditComment.fields("content.body").collect(&:content).collect(&:body).compact.collect(&:to_s).collect(&:downcase).join(" ").split(" ").sort_by{|k,v| v}.reverse.collect(&:first)
  end
  def perform
    terms.each do |term|
      Snowballer.perform_async(term)
    end
  end
end