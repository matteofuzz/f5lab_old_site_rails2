xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "F5lab Blog"
    xml.description "the official blog of F5lab and Matteo on Rails"
    xml.link 'http://f5lab.com/blog'

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link 'http://f5lab.com/blog/'+post.id.to_s
      end
    end
  end
end