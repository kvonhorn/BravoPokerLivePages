# Models a poker room page on the Bravo Poker Online website.

require_relative './bravopoker_page.rb'

module BravoPokerLivePages

class PokerRoomPage < BravoPokerPage
  
  @@running_table = '//table//th[contains(.,"Description")]/../..'
  @@waitlist_table = '//table//th[contains(.,"Players Waiting")]/../..'

  attr_reader :running_table, :waitlist_table
  
  
  def initialize(driver, baseurl='/')
    super(driver, baseurl)
  end


  def get_live_info
    live_info = Hash.new{ |h,k| h[k] = {:running=>nil, :wait_list=>nil} }
    
    running_tables = @driver.find_elements(:xpath, @@running_table)
    running_tables.each do |running_table|
      running_trs = running_table.find_elements(:tag_name, 'tr')
      running_trs.each do |running_tr|
        game, num_tables = running_tr.text.split(/\s+\b(?=\d+\s*$)/)
      
        live_info[game][:running] = num_tables unless num_tables.nil?
        num_tables = nil
      end
    end
    
    waitlist_tables = @driver.find_elements(:xpath, @@waitlist_table)
    waitlist_tables.each do |waitlist_table|
      waitlist_trs = waitlist_table.find_elements(:tag_name, 'tr')
      waitlist_trs.each do |waitlist_tr|
        game, num_waiting = waitlist_tr.text.split(/\s+\b(?=\d+\s*$)/)
      
        live_info[game][:wait_list] = num_waiting unless num_waiting.nil?
        num_waiting = nil
      end
    end
    
    live_info
  end
  
end

end