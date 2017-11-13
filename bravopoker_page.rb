# Base page object for Bravo Poker Live pages

require 'addressable'

class BravoPokerPage

  @@url = 'http://www.bravopokerlive.com'

  attr_reader :url, :driver
  attr_accessor :baseurl


  def initialize(driver, baseurl='/')
    @driver = driver
    @baseurl = baseurl
  end


  def get
    url_to_get = Addressable::URI.parse(@@url).join(@baseurl).to_s
    @driver.get url_to_get
  end

end
