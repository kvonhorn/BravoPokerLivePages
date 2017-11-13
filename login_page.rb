# Models the Login button and dialog on the /venues page

module LoginPage

  @@login_button_id = 'nav-login'
  @@login_modal_id = 'loginModal'
  @@email_textbox_id = 'Email'
  @@password_textbox_id = 'Password'
  @@login_to_your_account_button =
    '//button[contains(text(),"Login to your account")]'

  attr_reader :login_button_id, :login_modal_id, :email_textbox_id,
    :password_textbox_id, :login_to_your_account_button


  def logged_in?
    login_buttons = @driver.find_elements(:id, @login_button_id)
    return login_buttons.any?{ |button| button.displayed? }
  end


  def click_login_button
    login_buttons = @driver.find_elements(:id, @login_button_id)
    visible_button = login_buttons.find{ |button| button.visible? }
    visible_button.click if visible_button

    self
  end


  def login_modal_displayed?
    modals = @driver.find_elements(:id, @@login_modal_id)
    return modals.any?{ |modal| modal.displayed? }
  end


  def set_text_via_javascript(element_id, text)
    @driver.execute_script("document.getElementById('#{element_id}').setAttribute('value', '#{text}')");
  end
  protected :set_text_via_javascript


  def login_as(username, password, timeout=15)
    #return self if logged_in?

    self.click_login_button
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    modal = wait.until { @driver.find_element(:id, @@login_modal_id) }

    # NOTE: I have to make sure I have Chromedriver 2.31 installed
    # before I can call send_keys
    # Hmm, looks like the latest available through Debian is 2.30. I
    # may have to just send the keys through JavaScript calls. :P
    ##modal.find_element(:id, @@email_textbox_id).clear.send_keys(username)
    ##modal.find_element(:id, @@password_textbox_id).
    ##  clear.send_keys(password)

    set_text_via_javascript(@@email_textbox_id, username)
    set_text_via_javascript(@@password_textbox_id, password)
    modal.find_element(:xpath, @@login_to_your_account_button).click

    self
  end
end

