class Slide < ActiveRecord::Base

  # ISTANCE METHOD THAT DRAW THE SLIDE IN PNG IN /public/images/slideshow
  def draw_slide(font="handwriting")
    require 'RMagick'

    if self.sequence == "default"
      @font = "#{RAILS_ROOT}/public/font/BARBARJA-1.ttf"
      @point = 22
      @chars = 68
    elsif self.sequence == "horoscopes"
      @font = "#{RAILS_ROOT}/public/font/cour.ttf"
      @point = 12
      @chars = 84
    else
      @font = "#{RAILS_ROOT}/public/font/MONACO.TTF"
      @point = 10
      @chars = 74
    end
    slide_text = "#{format_lines(self.title.upcase+": "+self.text, @chars)}"
    slide_image = Magick::Image.new(600, 200) {self.background_color = "transparent"}
    text = Magick::Draw.new
    text.font = @font
    text.pointsize = @point
    text.text_align(Magick::LeftAlign)
    text.annotate(slide_image,
                  600,@point,
                  18,12+@point,
                  slide_text) {self.fill = 'white'; self.stroke = 'none'}
    slide_image.write("#{RAILS_ROOT}/public/images/slideshow/slide_#{self.sequence}_#{self.id}.png")
    self.image_path = "/images/slideshow/slide_#{self.sequence}_#{self.id}.png"
    self.save
  end

  def format_lines(textchars,maxchars)
    index0 = 0
    index1 = 0
    textlength = textchars.length
    lines = []
    while index0<textlength do
        index1 = textchars[index0...textlength].index("\n")
        if index1
          index1 += index0
        else
          index1 ||= textlength
        end
        line = textchars[index0...index1]
        while line.length > maxchars do
            subline = line[0...maxchars]
            subline.gsub!(/[\s\r\n\.,;:][\w\d]+$/, " ")
            lines << subline
            line = line[(subline.length)...line.length]
        end
        lines << line
        index0 = index1+1
    end
    formatted = ""
    lines.each {|line| formatted << line+"\n" }
    formatted.gsub!(/\n\n/,"\n")
    return formatted
  end

  # CLASS METHOD THAT GRAB THE CURRENT HOROSCOPES ON ROB BREZNY SITE
  # AND LOAD EVERY SIGN ON A SLIDE OBJECT
  def self.load_horoscopes
      site = "http://www.freewillastrology.com/horoscopes"
      signs = ["aries", "taurus", "gemini", "cancer", "leo", "virgo", "libra", "scorpio",
              "sagittarius", "capricorn", "aquarius", "pisces"]
      targets = signs.map {|s| site+"/"+s+".html"}
      csspath = "html body div table tr td p"
      horoscopes = {}

      signs.each_index do |i|
        horoscopes[signs[i]] = grab(targets[i],csspath )
      end

      signs.each do |s|
        signslide = Slide.find_by_sequence_and_title('horoscopes',s)
        signslide ||= Slide.new
        signslide.title = s
        signslide.sequence = "horoscopes"
        if horoscopes[s]
          signslide.text = horoscopes[s]
        else
          signslide.text = "DEFAULT TEXT"
        end
        signslide.save
        signslide.draw_slide
        signslide.save
      end
  end

  def self.grab(target,csspath)
      require 'hpricot'
      require 'open-uri'
        # load and parse the page
      user_agent = "RoR_Grabber_F5lab"
      doc = Hpricot(open(target), "User-Agent" => user_agent)
      grabbed = doc.search(csspath).first
      grabbed.search("img,p,br").remove
      grabbed = grabbed.inner_html
        # < br/> => \n
      grabbed.gsub!(/<\s+"br"\/>/,"\n")
        # delete HTML grabbed
      grabbed.gsub!(/<[\w\/][\s\d\w\-\+="'\/_:;\.~\?!]*>/,"")
        # remove all whitespace at the beginning
      grabbed.lstrip!
  end

  # SCRIPT UTILITY THAT REDRAW ALL SLIDES
  # LAUNCH WITH SCRIPT/RUNNER
  def self.redraw_all_slides
    @slides = Slide.find(:all)
    @slides.each do |s|
      s.draw_slide
      s.save
    end
  end

end
