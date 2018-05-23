# rubocop:disable Lint/Debugger, HandleExceptions
# rubocop:disable BlockLength
require 'securerandom'

# 1. ========= BROWSE ACTIONS ===========
# 1.1 Visit a URL
When(/^I visit the url "([^"]*)"$/) do |url|
  visit url
  @pos_number = {
    fifth_last: -4,
    fourthlast: -3,
    third_last: -2,
    second_last: -1,
    last: 0, # 0 - 1 will be -1 in ruby index
    first: 1,
    second: 2,
    third: 3,
    fourth: 4,
    fifth: 5,
    sixth: 6,
    seventh: 7,
    eighth: 8,
    nineth: 9,
    tenth: 10,
    eleventh: 11,
    twelveth: 12,
    thirdteeenth: 13
  }
end

# 2. ========= CLICK ACTIONS =============
# 2.1 Click on a button or a link
When(/^I click on "([^"]*)"$/) do |content|
  el = first(:xpath, ".//*[contains(text(), '#{content}')]")
  el ||= first(:xpath, ".//*[@value='#{content}']")
  el.click
end

# 2.2 Click on a button (in case you have a link with the same display)
When(/^I click on button "([^"]*)"$/) do |content|
  el = first(:xpath, ".//button[contains(text(), '#{content}')]")
  el ||= first(:xpath, ".//input[@value='#{content}']")
  el.click
end

# 2.3 Click on the link (in case you have a link with the same display)
When(/^I click on the link "([^"]*)"$/) do |arg1|
  click_link arg1
end

# 2.4 Click on the first link
When(/^I click on the first link "([^"]*)"$/) do |arg1|
  first(:link, arg1).click
end

# 2.4 Click on link or button with an attribute value
When(/^I click on "([^"]*)" with attribute "([^"]*)" value "([^"]*)"$/) \
do |content, attribute, attribute_value|
  el = first(:xpath, ".//*[contains(text(), '#{content}') and \
contains(@#{attribute}, '#{attribute_value}')]")
  el ||= first(:xpath, ".//input[@value='#{content}' and \
contains(@#{attribute}, '#{attribute_value}')]")
  el.click
end

# 2.5 Click on a random element with an attribute value
When(/^I click on tag "([^"]*)" with attribute "([^"]*)" value "([^"]*)"$/) \
do |tag, attribute, attribute_value|
  el = first(:xpath, ".//#{tag}[contains(@#{attribute}, '#{attribute_value}')]")
  el.click
end

# 2.6 Click on a button in the same row as something that I can see
When(/^I click on ([^"]*) "([^"]*)" with attribute "([^"]*)" value "([^"]*)" \
in the same row as "([^"]*)"$/) \
do |position, tag, attribute, attribute_value, seeable_content|
  parent_el = find(:xpath, ".//tr[td[contains(text(), '#{seeable_content}')]]")
  pos_number = @pos_number[position.to_sym]

  els = all(:xpath, "#{parent_el.path}//\
#{tag}[contains(@#{attribute}, '#{attribute_value}')]")
  els[pos_number - 1].click
end

# 2.7 Click on ordered element
When(/^I click on the ([^"]*) "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)"/) do |position, tag, attribute, attribute_value|
  pos_number = @pos_number[position.to_sym]
  els = all(:xpath, ".//#{tag}[contains(@#{attribute}, '#{attribute_value}')]")
  els[pos_number - 1].click
end

# 2.8 Click on a tag in the same box as something that I can see
When(/^I click on the ([^"]*) "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)" within the same box as "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)" as "([^"]*)"$/) \
do |position, tag, attribute, attribute_value, box_tag, box_attribute_name, box_attribute_value, seeable_content|
  parent_el =
    find(:xpath,
         ".//#{box_tag}[contains(@#{box_attribute_name}, \
         '#{box_attribute_value}')]\
         //*[contains(text(), '#{seeable_content}')]")

  pos_number = @pos_number[position.to_sym]
  els = all(:xpath, "#{parent_el.path}//\
#{tag}\
[contains(@#{attribute}, '#{attribute_value}')]")
  els[pos_number - 1].click
end

# 2.9 Click on a special tag with text value
Then(/^I click on the ([^"]*) "([^"]*)" with text "([^"]*)"$/) \
do |position, tag, text|
  pos_number = @pos_number[position.to_sym]
  els = all(:xpath, ".//#{tag}[text()='#{text}']")
  el = els[pos_number - 1]
  el.set(value)
end

# 3. ========= FILL FORM ACTIONS ===========
# 3.1 Fill in a text field (given that the text field and the
# label are connected)
When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field_name, field_value|
  fill_in field_name, with: field_value
end

# 3.2 Fill in a text field identified by placeholder
Then(/^I fill in field with placeholder "([^"]*)" with "([^"]*)"$/) \
do |placeholder, value|
  first(:xpath, ".//*[@placeholder='#{placeholder}']").set(value)
end

# 3.3 Fill in a text field by field type
Then(/^I fill in field with type "([^"]*)" with "([^"]*)"$/) \
do |field_type, value|
  first(:xpath, ".//*[@type='#{field_type}']").set(value)
end

# 3.4  Fill in a field with name
When(/^I fill in field name "([^"]*)" with "([^"]*)"$/) do |name, value|
  first(:xpath, ".//*[@name='#{name}']").set(value)
end

# 3.5  Fill in a field identify by an attribute of the field
When(/^I fill in field with attribute "([^"]*)" value "([^"]*)" \
with "([^"]*)"$/) do |attribute, attribute_value, field_value|
  input = first(:xpath, ".//*[contains(@#{attribute}), '#{attribute_value}')]")
  if input.readonly?
    page.execute_script \
      "document
        .querySelector(
          'input[#{attribute}=\"#{attribute_value}\"]'
        ).readOnly = false;"
  end
  input.set(field_value)
end

# 3.6 Select an option from a dropdown box
When(/^I select "([^"]*)" from "([^"]*)"$/) do |option, select|
  select option, from: select
end

# 3.7. Select an option from a dropdown box identified by attribute
When(/^I select "([^"]*)" from drop down with \
attribute "([^"]*)" value "([^"]*)"$/) do |option, attribute, value|
  select = first(:xpath, ".//select[contains(@#{attribute}, '#{value}')]")

  if select.nil?
    select = first(:xpath, ".//select[contains(@#{attribute}, '#{value}')]",
                   visible: false)
    if select.ni?
      raise "No such select found with attribute \"#{attribute}\" ~= \"#{value}\""
    end
  end

  option = select.find(:xpath, "option[contains(text(), '#{option}')]")

  raise "No option found with text #{option}" if option.nil?
  option.select_option
end

# 3.7a. Select an option from a dropdown with position box
# identified by attribute
When(/^I select "([^"]*)" from ([^"]+) drop down with \
attribute "([^"]*)" value "([^"]*)"$/) do |option, position, attribute, value|
  selects = all(:xpath, ".//select[contains(@#{attribute}, '#{value}')]")
  select = selects[@pos_number[position.to_sym] - 1]

  if select.nil?
    selects = all(:xpath, ".//select[contains(@#{attribute}, '#{value}')]",
                  visible: false)
    select = selects[@pos_number[position.to_sym] - 1]
    if select.nil?
      raise "No such select found with attribute \"#{attribute}\" ~= \"#{value}\""
    end

    page.execute_script \
      "var select =
        document.evaluate(
            \"#{select.path}\",
            document,
            null,
            XPathResult.FIRST_ORDERED_NODE_TYPE,
            null).singleNodeValue;
      for(let child in select.children) {
        if(select.children[child].innerHTML == \"#{option}\") {
          select.children[child].selected = \"selected\";
        }
      };
      var evt = document.createEvent(\"HTMLEvents\");
      evt.initEvent('change', false, true);
      select.dispatchEvent(evt);"
  else
    option =
      select
      .find(:xpath, "option[contains(text(), '#{option}')]")

    raise "No option found with text #{option}" if option.nil?
    option.select_option
  end
end

# 3.8 Select a date in date picker
# Use the command to fill in a text field

# 3.9 Upload a file
When(/^I attach file to "([^"]*)" with "([^"]*)"$/) do |field_name, file_path|
  root_folder = Dir.pwd
  attach_file field_name, "#{root_folder}/uploads/#{file_path}"
end

# 3.10  Fill in a with class name
When(/^I fill in ([^"]*) field with attribute "([^"]*)" value "([^"]*)" with \
"([^"]*)"$/) do |position, attribute_name, attribute_value, value|
  pos_number = @pos_number[position.to_sym]

  els = all(:xpath, ".//*[contains(@#{attribute_name}, '#{attribute_value}')]")
  el = els[pos_number - 1]
  el.set(value)
end

# 3.11 Upload a file
When(/^I attach file to field with attribute "([^"]*)" value "([^"]*)" with \
"([^"]*)"$/) do |attribute_name, attribute_value, file_path|
  root_folder = Dir.pwd

  page.execute_script \
    "document
        .querySelector(
          \"input[#{attribute_name}*='#{attribute_value}']\"
        ).classList.remove('hide');"

  page.execute_script \
    "document
        .querySelector(
          \"input[#{attribute_name}*='#{attribute_value}']\"
        ).classList.remove('hidden');"

  page.execute_script \
    "document
        .querySelector(
          \"input[#{attribute_name}*='#{attribute_value}']\"
        ).style.display = 'block';"

  el = first(:xpath,
             ".//input[contains(@#{attribute_name}, '#{attribute_value}')]")
  unless el
    raise "No such file field found with \
attribute \"#{attribute_name}\" ~= \"#{attribute_value}\""
  end

  if el['name'] && el['name'] != ''
    attach_file el['name'],
                "#{root_folder}/uploads/#{file_path}",
                visible: false
  else
    # for input without a name, we will create a name
    unique_name = SecureRandom.uuid
    page.execute_script \
      "document
          .querySelector(
            'input[#{attribute_name}*=\"#{attribute_value}\"]'
          ).name = 'uploaded_file_#{unique_name}';"
    attach_file "uploaded_file_#{unique_name}",
                "#{root_folder}/uploads/#{file_path}",
                visible: false
  end
end

# 3.12 Fill in a special tag
When(/^I fill in ([^"]*) "([^"]*)" with value "([^"]*)"$/) \
do |position, tag, value|
  pos_number = @pos_number[position.to_sym]
  els = all(:xpath, ".//#{tag}")
  el = els[pos_number - 1]
  el.set(value)
end

# 4. ========= CHECKING ACTIONS ===========
# 4.1 Check what can be seen on the page
Then(/^I should see "([^"]*)"$/) do |arg1|
  assert page.has_content?(arg1)
end

# 4.2 Advanced checking of content based on html tag
Then(/^I should see tag "([^"]*)" with content "([^"]*)"$/) do |tag, content|
  assert page.has_selector?(tag, text: content, visible: true)
end

# 4.3 Check for attribute name vs value
# I should see tag "div" with attribute "id" filled in "james"
Then(/^I should see tag "([^"]*)" with attribute "([^"]*)" \
filled with "([^"]*)" has attribute "([^"]*)" filled with "([^"]*)"$/) \
do |tag, attr_name, attr_value, attr2_name, attr2_value|
  Capybara.ignore_hidden_elements = false
  el = first(:xpath, ".//#{tag}[@#{attr_name}='#{attr_value}']")
  Capybara.ignore_hidden_elements = true
  assert !el.nil?

  assert el[attr2_name] == attr2_value
end

# 4.4 Check for checked checkbox
# I should see tag "div" with attribute "id" filled in "james"
Then(/^I should see checkbox with attribute "([^"]*)" \
filled with "([^"]*)" "([^"]*)"$/) \
do |attr_name, attr_value, checked_cond|
  Capybara.ignore_hidden_elements = false
  el = first(:xpath, ".//input[@#{attr_name}='#{attr_value}']")
  Capybara.ignore_hidden_elements = true
  assert !el.nil?

  assert el.checked? == (checked_cond == 'checked')
end

# 4.5 Check for checked checkbox
# I should see "hello" "6" times
Then(/^I should see "([^"]*)" "([^"]*)" time\(s\)$/) \
do |text, number_of_times|
  el = all(:xpath, ".//*[contains(text(), '#{text}')]")
  assert el.length == number_of_times.to_i
end

# 5. ========= MISC ACTIONS ===========
# 5.1 Pause
Then(/^pause for ([^"]*) seconds$/) do |duration|
  sleep duration.to_i
end

# 5.2 Take screenshot
Then(/^I take screenshot$/) do
  save_screenshot(nil, full: true)
end

# 5.3 Scroll down
Then(/^I scroll down "([^"]*)"$/) do |scroll|
  scroll = scroll.gsub('px', '')
  page.execute_script "window.scrollBy(0, #{scroll})"
end

# 6. ========== ADVANCED SELECTOR ==========
# 6.1 Perform action in iframe
Then(/^(.*) in the iframe "([^"]*)"$/) do |step, iframe_name|
  browser = page.driver.browser
  browser.switch_to.frame(iframe_name)
  step(step)
  browser.switch_to.default_content
end

# 6.2 Perform action and ignore if error occurs
Then(/^(.*) if available$/) do |step|
  begin
    step(step)
  rescue
    # do nothing
  end
end

# 6.3 within first tag with attribute ... value ...
Then(/^(.*) within ([^"]*) "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)"/) do |step, position, tag, attribute_name, attribute_value|
  pos_number = @pos_number[position.to_sym]
  els = all(:xpath,
            ".//#{tag}[contains(@#{attribute_name}, '#{attribute_value}')]")
  el = els[pos_number - 1]

  within(:xpath, el.path) do
    step(step)
  end
end

# 6.4 In browser
Then(/^(.*) in browser "([^"]*)"/) do |step, browser_name|
  in_browser(browser_name.to_sym) do
    step(step)
  end
end

# 7. ========= MEMORY ==============
# 7.1 Remember a variable
Then(/^I remember "([^"]*)" as "([^"]*)"$/) do |name, value|
  instance_variable_set("@#{name}", value)
end

# 7.2 Remember as content of a div
Then(/^I remember "([^"]*)" as content of "([^"]*)" with attribute "([^"]*)" \
value "([^"]*)"$/) do |name, tag, attribute, value|
  content = first(:xpath, ".//#{tag}[@#{attribute}='#{value}']")['innerText']
  instance_variable_set("@#{name}", content)
end

# ============== TRANSFORMING =====================
Transform(/^\[([^"]*)\]$/) do |string|
  val = instance_variable_get("@#{string}")
  if val
    val
  else
    string
  end
end

# 8.1 Transform date & time
Transform(/^([^"]*) from now( with format ([^"]*))?$/) \
do |string, _tmp, format|
  number = string.split(' ')[0]
  unit = string.split(' ')[1]
  date_format = case format
                when 'd-m-y'
                  '%d-%m-%Y'
                when 'y-m-d'
                  '%Y-%m-%d'
                when 'm-d-y'
                  '%m-%d-%Y'
                else
                  '%d-%m-%Y'
                end
  (Date.today + number.to_i.send(unit)).strftime(date_format)
end

Transform(/^([^"]*) prior to now( with format ([^"]*))?$/) \
do |string, _tmp, format|
  number = string.split(' ')[0]
  unit = string.split(' ')[1]
  date_format = case format
                when 'd-m-y'
                  '%d-%m-%Y'
                when 'y-m-d'
                  '%Y-%m-%d'
                when 'm-d-y'
                  '%m-%d-%Y'
                else
                  '%d-%m-%Y'
                end
  (Date.today - number.to_i.send(unit)).strftime(date_format)
end

Transform(/^(first|second|third|fourth|fifth) last$/) \
do |string|
  "#{string}_last"
end
