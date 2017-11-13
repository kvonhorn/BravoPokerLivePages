# Model the Bravo Poker /venues page. This is the home page. It
# contains a Venue List table, a Casino Filter search box, and
# a Login button/dialog.

require_relative './bravopoker_page.rb'
require_relative './login_page.rb'

class VenuesPage < BravoPokerPage

  include LoginPage

  @@base_url = '/venues'

  attr_reader :base_url

=begin
2.4.1 :115 > @driver.execute_script("arguments[0].scrollIntoView();", ameristar[0])
 => nil
2.4.1 :116 > ameristar[0].click
 => nil

=end

  def initialize(driver, baseurl=@@base_url)
    super(driver, baseurl)
  end


  def find_tag_containing_text(tag, text)
    tags = @driver.find_elements(:xpath,
                                 "//#{tag}[contains(text(),#{text.strip})]")
    tags
  end
  
end
