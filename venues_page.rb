# Model the Bravo Poker /venues page. This is the home page. It
# contains a Venue List table, a Casino Filter search box, and
# a Login button/dialog.

require_relative './bravopoker_page.rb'
require_relative './login_page.rb'
require_relative './poker_room_page.rb'


module BravoPokerLivePages

class VenuesPage < BravoPokerPage

  include LoginPage

  @@base_url = '/venues'

  attr_reader :base_url


  def initialize(driver, baseurl=@@base_url)
    super(driver, baseurl)
  end


  def find_tag_containing_text(tag, text)
    tags = @driver.find_elements(:xpath,
                                 "//#{tag}[contains(text(),'#{text.strip}')]")
    tags
  end
  
  
  # Click the first link containing the supplied text. Returns a PokerRoomPage
  #   if the text was found, and self if the text was not found.
  def click_casino_name(casino_name)
    page_out = nil
    casinos = find_tag_containing_text('a', casino_name)
    
    if casinos.length > 0
      # TODO: Put this into a utility method?
      @driver.execute_script('arguments[0].scrollIntoView();', casinos[0])
      casinos[0].click
 
      baseurl = Addressable::URI.parse(@driver.current_url).path
      page_out = PokerRoomPage.new(@driver, baseurl)
    else
      # Click nothing
      # TODO: Log a message that there was nothing to click?
      page_out = self
    end
    
    page_out
  end
  
end

end