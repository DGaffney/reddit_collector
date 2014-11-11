# encoding: UTF-8
class String

  CURRENT_STOPWORD_LOCALES = [:bg, :da, :de, :en, :es, :fn, :fr, :hu, :it, :nl, :pt, :ru, :sv]
  ATEXT = /[A-Za-z0-9!#\$%&'\*\+\-\/=\?\^_`\{\|\}\~]/
  DOT_ATOM = /(?:#{ATEXT})+(?:\.(?:#{ATEXT})+)*/

  TEXT = /[\x01-\x09\x0B\x0C\x0E-\x7F]/
  QTEXT = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7E]/
  QUOTED_PAIR = /\\#{TEXT}/
  QCONTENT = /(?:#{QTEXT}|#{QUOTED_PAIR})/
  QUOTED_STRING = /"(?:\s*#{QCONTENT})*\s*"/

  DTEXT = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21-\x5A\x5E-\x7E]/
  DCONTENT = /(?:#{DTEXT}|#{QUOTED_PAIR})/
  DOMAIN_LITERAL = /\[(?:\s*#{DCONTENT})*\s*\]/
  DOMAIN = /(?:#{DOT_ATOM}|#{DOMAIN_LITERAL})/

  LOCAL_PART = /(?:#{DOT_ATOM}|#{QUOTED_STRING})/

  ADDR_SPEC = /^(#{LOCAL_PART})@(#{DOMAIN})$/

  def url?
    return !(self =~ URI::regexp).nil?
  end
  
  def valid_email_address?
    result = (self =~ ADDR_SPEC)
    return !result.nil?
  end
  
  def blank?
    the_match = /^\s*$/.match(self)
    the_match.to_s.size == self.size
  end

  def to_url
    url = URI.parse(URI.escape(self.strip)).to_s
    url
  end
  
  def underscore_to_pretty
    self.split("_").collect(&:capitalize).join(" ")
  end

  def truncate(opts={})
    opts = opts
    opts[:length] ||= 30
    opts.ending_character ||= ""
    set = ""
    text = self.split(" ")
    text.each do |word|
      set = "#{set}#{word} " if opts[:length] >= (set.length + word.length)
    end
    set+opts.ending_character
  end

  def linkify(attributes={})
    attributes = " "+attributes.collect{|k,v| "#{k}=\"#{v.gsub("\"", "\\\"")}\""}.join(" ")
    self.gsub!(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%.\w_]*)#?(?:[\w]*))?)/) {|possible_url| possible_url.valid_email_address? ? "<a href=\"mailto:#{possible_url}\">#{possible_url}</a>" : "<a href=\"#{possible_url}\" target=\"_blank\"#{attributes}>#{possible_url}</a>"}
    self.gsub!(/(\W|^)(#\w*)/) {|hashtag| "<a href=\"https://twitter.com/search?q=#{URI.escape(hashtag)}\" target=\"_blank\"#{attributes}>#{hashtag}</a>"}
    self.gsub!(/(\W|^)@(\w*)/, '\1<a href="https://twitter.com/\2" target="_blank"'+attributes+'>@\2</a>')
    self
  end

  def linkify_with_twitter_entities(entities)
    entities = entities
    urls = entities.urls.collect{|url| url.url }.uniq
    hashtags = entities.hashtags.collect{|hashtag| hashtag.text}.uniq
    user_mentions = entities.user_mentions.collect{|user_mention| user_mention.screen_name}.uniq
    urls.each do |url|
      self.gsub!(url, "<a href=\"#{url}\" target=\"_blank\">#{url}</a>")
    end
    hashtags.each do |hashtag|
      self.gsub!("##{hashtag}", "<a href=\"http://twitter.com/search?q=%23#{hashtag}\" target=\"_blank\">##{hashtag}</a>")
    end
    user_mentions.each do |user_mention|
      self.gsub!("@#{user_mention}", "<a href=\"http://twitter.com/#{user_mention}\" target=\"_blank\">@#{user_mention}</a>")
    end
    self
  end
  
  def md5
    Digest::SHA1.hexdigest(self)
  end


  def camel_split
    self.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2').tr("-", " ")
  end

  def parse_multiple_locations
    self.split(/[&|]/).collect{|sub_str| sub_str.location_clean}
  end

  def location_clean
    self.downcase.remove_stopwords.split(/[.\*-=+~_^%\$\#\@\!\(\)\\<>\?]/).collect(&:strip)
  end

  def extract_name
    name_parts = {}
    name_parts[:first_name] = self.split(" ").first if self.split(" ").first.first_name?
    name_parts[:last_name] = self.split(" ").last
    name_parts[:full_name] = self
    name_parts
  end
  
  def strip_unicode
    self.gsub(/\u0001/, '')
  end
end