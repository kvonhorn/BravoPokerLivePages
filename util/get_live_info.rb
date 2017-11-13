# Get the live info off of a Bravo Poker cash game page

require_relative '../venues_page.rb'
require 'json'
require 'optparse'
require 'selenium-webdriver'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options]"

  opts.on('-u', '--uid USERNAME', 'Bravo Poker Username') do |uid|
    options[:uid] = uid
  end

  opts.on('-p', '--pw PASSWORD', 'Bravo Poker Password') do |pw|
    options[:pw] = pw
  end

  opts.on('-r', '--room POKER ROOM',
          'Name of the poker room to get info for' ) do |room|
    options[:room] = room
  end

  opts.on_tail('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end.parse!  


if not (options[:uid] and options[:pw])
  if (not options[:uid] and not options[:pw])
    raise OptionParser::MissingArgument.new(
      'Missing options -u UID -p PW required')
  elsif not options[:uid]
    raise OptionParser::MissingArgument.new(
      'Missing option -u UID required')
  else
    raise OptionParser::MissingArgument.new(
      'Missing option -p PW required')
  end
end

# TODO: Get these from the environment?
uid = options[:uid]
pw = options[:pw]


# Set up Chrome
chromedriver_path = Selenium::WebDriver::Chrome.driver_path=`which chromedriver`.chomp
puts "Using chromedriver at #{chromedriver_path}"

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  'chromeOptions' => {
    "args" => [ "--headless", "--disable-gpu" ]
  }
)

@driver_quit_called = false
at_exit do
  @driver.quit unless @driver.nil? or @driver_quit_called
end


@driver = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities


# Get the home page
home_page = VenuesPage.new(@driver)
puts "Getting home page"
home_page.get
puts "Current URL: #{@driver.current_url}"


# TODO: check to see if logged in. Log in if not
logged_in = home_page.logged_in?
puts "Logged in? #{logged_in}"
#require 'irb'; binding.irb
#home_page.login_as(uid, pw)
@driver.close; @driver.quit; @driver_quit_called = true; puts 'Sleeping 10'; sleep 10; exit 1
# TODO: Find the link on the page like poker_room_name and click it
# TODO: Scrape the live info

# Load the poker room page
##poker_room_name = 'red-hawk-casino-placerville'
#poker_room_name = 'bicycle-casino-bell-gardens'
#poker_room_page = PokerRoomPage.new @driver, "/poker-room/#{poker_room_name}"
#poker_room_page.get
#
#
## Get all the data
#live_info = poker_room_page.get_live_info
#puts JSON.pretty_generate(live_info)
#
#
#@driver.quit
#@driver_quit_called = true
