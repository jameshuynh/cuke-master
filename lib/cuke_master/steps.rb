# rubocop:disable Lint/Debugger, HandleExceptions

# 1. ========= BROWSE ACTIONS ===========
# 1.1 Visit a URL
When(/^I visit the url "([^"]*)"$/) do |url|
  visit url
  @pos_number = {
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
  el = first(:xpath, ".//*[@value='#{content}']") unless el
  el.click
end

# 2.2 Click on a button (in case you have a link with the same display)
When(/^I click on button "([^"]*)"$/) do |content|
  el = first(:xpath, ".//button[contains(text(), '#{content}')]")
  el = first(:xpath, ".//input[@value='#{content}']") unless el
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
  unless el
    el = first(:xpath, ".//input[@value='#{content}' and \
contains(@#{attribute}, '#{attribute_value}')]")
  end
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

  el = first(:xpath, "#{parent_el.path}//\
#{tag}\
[contains(@#{attribute}, '#{attribute_value}')]\
[position()=#{pos_number}]")
  el.click
end

# 2.7 Click on ordered element
When(/^I click on the ([^"]*) "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)"/) do |position, tag, attribute, attribute_value|
  pos_number = @pos_number[position.to_sym]
  el = first(:xpath, ".//#{tag}[contains(@#{attribute}, '#{attribute_value}')]\
[position()=#{pos_number}]")
  el.click
end

# 2.8 Click on a tag in the same box as something that I can see
When(/^I click on the ([^"]*) "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)" within the same box as "([^"]*)" with attribute "([^"]*)" value \
"([^"]*)" as "([^"]*)"$/) \
do |position, tag, attribute, attribute_value, box_tag, \
box_attribute_name, box_attribute_value, seeable_content|
  parent_el =
    find(:xpath,
         ".//#{box_tag}[contains(@#{box_attribute_name}, \
         '#{box_attribute_value}')]\
         //*[contains(text(), '#{seeable_content}')]")

  pos_number = @pos_number[position.to_sym]
  el = first(:xpath, "#{parent_el.path}//\
#{tag}\
[contains(@#{attribute}, '#{attribute_value}')]\
[position()=#{pos_number}]")
  el.click
end

# 2.9 Click on a special tag with text value
Then(/^I click on the ([^"]*) "([^"]*)" with text "([^"]*)"$/) \
do |position, tag, text|
  pos_number = @pos_number[position.to_sym]
  el = first(:xpath, "//#{tag}[text()='#{text}'][position()=#{pos_number}]")
  el.click
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
    raise "No such select found with attribute \"#{attribute}\" ~= \"#{value}\""
  end

  option = select.find(:xpath, "option[contains(text(), '#{option}')]")

  raise "No option found with text #{option}" if option.nil?
  option.select_option
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
          'input[#{attribute_name}=\"#{attribute_value}\"]'
        ).style.display = 'block';"
  page.execute_script \
    "document
        .querySelector(
          'input[#{attribute_name}=\"#{attribute_value}\"]'
        ).name = 'uniqueFieldForCapybara';"

  attach_file 'uniqueFieldForCapybara',
              "#{root_folder}/uploads/#{file_path}",
              visible: false
end

# 3.12 Fill in a special tag
When(/^I fill in ([^"]*) "([^"]*)" with value "([^"]*)"$/) \
do |position, tag, value|
  pos_number = @pos_number[position.to_sym]
  first(:xpath, ".//#{tag}[position()=#{pos_number}]").set(value)
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
  within(:xpath,
         ".//#{tag}[contains(@#{attribute_name}, '#{attribute_value}')]\
[position()=#{pos_number}]") do
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

# ============== TRANSFORMING =====================
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
