require 'capybara'
require 'selenium-webdriver'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'minitest/autorun'
require 'capybara-screenshot/cucumber'
require 'active_support/all'

Capybara.run_server = false
Capybara.register_driver :headless_chrome do |app|
  path =
    [
      '/Applications',
      "Google\ Chrome.app",
      'Contents/MacOS/',
      "Google\ Chrome"
    ].join('/')

  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      binary: path,
      # args: %w[--headless --disable-gpu --no-sandbox window-size=1440,968]
      args: %w[--disable-gpu --no-sandbox window-size=1400,5000]
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: caps
  )
end

# Capybara.default_max_wait_time = 30
Capybara.default_max_wait_time = 5
Capybara.default_driver = :headless_chrome
Capybara.save_path = './screenshots'
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.prune_strategy = :keep_last_run

def in_browser(name)
  old_session = Capybara.session_name

  Capybara.session_name = name
  yield

  Capybara.session_name = old_session
end
