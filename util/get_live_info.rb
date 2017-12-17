# Get the live info off of a Bravo Poker cash game page

require_relative '../venues_page.rb'
require 'logger'
require 'json'
require 'optparse'
require 'selenium-webdriver'


@logger = Logger.new(STDOUT)
@logger.level = Logger::DEBUG
@logger.progname = $PROGRAM_NAME


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

# Note: These are some poker room names you can use; check the home page for more
# Set the default poker_room_name
#poker_room_name = 'Ameristar Black Hawk'
#poker_room_name = 'Atlantis Casino'
#poker_room_name = 'Boulder Station'
#poker_room_name = 'Caesars Palace'
#poker_room_name = 'Capitol Casino'
#poker_room_name = 'Commerce Casino'
#poker_room_name = 'Flamingo Las Vegas'
#poker_room_name = "Harvey's Lake Tahoe"
#poker_room_name = 'Peppermill Casino'
#poker_room_name = 'Planet Hollywood Las Vegas'
#poker_room_name = 'Red Rock Casino'
#poker_room_name = 'Silver Legacy'
#poker_room_name = 'The Orleans'
poker_room_name = 'Thunder Valley'


# TODO: Get these from the environment?
uid = options[:uid]
pw = options[:pw]
poker_room_name = options[:room] if options[:room]


# Set up Chrome
chromedriver_path = Selenium::WebDriver::Chrome.driver_path=`which chromedriver`.chomp
@logger.debug "Using chromedriver at #{chromedriver_path}"

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  'chromeOptions' => {
    "args" => [ "--headless", "--disable-gpu" ]
  }
)

@driver_quit_called = false
at_exit do
  unless @driver.nil? or @driver_quit_called
    #@driver.save_screenshot 'at_exit.png'
    @driver.quit
  end
end


@driver = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities


# Get the home page
home_page = BravoPokerLivePages::VenuesPage.new(@driver)
@logger.info "Getting home page"
home_page.get
@logger.info "Current URL: #{@driver.current_url}"


# Log in if necessary
logged_in = home_page.logged_in?
if not logged_in
  @logger.debug "Logging in as #{uid}"
  home_page.login_as(uid, pw)
end


# Find the link on the page containing the text in poker_room_name and click it
poker_room_page = home_page.click_casino_name(poker_room_name)


# Scrape the live info
live_info = poker_room_page.get_live_info
puts JSON.pretty_generate(live_info)


@driver.quit
@driver_quit_called = true
