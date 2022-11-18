*** Settings ***
Library    SeleniumLibrary
Resource    ../Resource/CommonKeywords.robot
Resource    ../Resource/CommonInventoryKeywords.robot
Variables    ../Locators/ButtonLocators.py
Variables    ../Locators/CheckoutPageLocators.py
Variables    ../TestData/CheckoutPageTestData.py

Suite Setup     open browser and maximize browser window
Suite Teardown    close browser and clear session

*** Variables ***
${standard_username}
${password}

${item_title}
${item_description}
${item_price}
${number_of_items}

*** Test Cases ***
Verify Swag Labs Page Title Logo & Mascot
    title should be     ${page_title}
    page should contain element   xpath://div[@class="${logo_locator}"]
    page should contain element   xpath://div[@class="${bot_locator}"]

Read and Store Username and Password
    ${username_text}=    get text    xpath://div/h4[contains(text(), "${accepted_username_locator}")]//parent::div
    ${username_text_split}=     split string    ${username_text}    \n
    set global variable     ${standard_username}    ${username_text_split}[1]
    ${password_text}=    get text    xpath://div/h4[contains(text(), "${password_locator}")]//parent::div
    ${password_text_split}=     split string    ${password_text}    \n
    set global variable     ${password}    ${password_text_split}[1]

Read Data from Excel and Store
    ${item_title_temp}   ${item_description_temp}     ${item_price_temp}   Read Inventory Data From CSV File and Return List
    set global variable     ${item_title}    ${item_title_temp}
    set global variable     ${item_description}    ${item_description_temp}
    set global variable     ${item_price}    ${item_price_temp}
    ${number_of_items_temp}=    get length  ${item_title}
    set global variable     ${number_of_items}    ${number_of_items_temp}

Verify Login With Valid Credentials
    input text    xpath://input[@placeholder="${username_locator}"]    ${standard_username}
    input text    xpath://input[@placeholder="${password_locator}"]    ${password}
    click element   xpath://input[@value="${button_text_login}"]
    wait until page contains element    xpath://div//span[contains(text(), "${inventory_page_title}")]

Verify Add Items to Cart
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        add item to cart and verify button text change   ${item_title}[${product_no}]
    END
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "6")]

Verify Remove Items from Cart
    remove item from cart and verify button text change    ${item_title}[5]
    remove item from cart and verify button text change    ${item_title}[1]
    remove item from cart and verify button text change    ${item_title}[0]
    remove item from cart and verify button text change    ${item_title}[2]
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "2")]
    click element   xpath://a[@class="${cart_counter_locator}"]

Verify Checkout step one and enter information
    click element   xpath://button[contains(text(), "${button_text_checkout}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${checkout_page_one_title}")]
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "${firstname_required_message}")]
    input text      xpath://input[@placeholder="${firstname_locator}"]      ${first_name}
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "${lastname_required_message}")]
    input text      xpath://input[@placeholder="${lastname_locator}"]      ${last_name}
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "${postal_code_required_message}")]
    input text      xpath://input[@placeholder="${postal_code_locator}"]      ${postal_code}

Verify Chackout step two
    click element   xpath://input[@value="${button_text_continue}"]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${checkout_page_two_title}")]
    verify cart item quantity, title, description, price   ${item_title}[3]   ${item_description}[3]     ${item_price}[3]
    verify cart item quantity, title, description, price   ${item_title}[4]   ${item_description}[4]     ${item_price}[4]
    ${payment_information_temp}=     get text   xpath://div[contains(text(), "${payment_information_locator}")]//following-sibling::div[1]
    should be equal as strings      ${payment_information_temp}     ${payment_information}
    ${shipping_information_temp}=   get text   xpath://div[contains(text(), "${shipping_information_locator}")]//following-sibling::div[1]
    should be equal as strings      ${shipping_information_temp}     ${shipping_information}
    ${item_total}=   get text    xpath://div[contains(text(), "${shipping_information_locator}")]//following-sibling::div[2]
    ${item_total_amount_string}=    Fetch From Right    ${item_total}   $
    ${item_total_amount_number}=     convert to number    ${item_total_amount_string}
    ${item_four_price_number}=      remove string    ${item_price}[3]    $
    ${item_four_price_number}=     convert to number    ${item_four_price_number}
    ${item_five_price_number}=      remove string    ${item_price}[4]    $
    ${item_five_price_number}=     convert to number    ${item_five_price_number}
    ${sum_amount}=  evaluate    ${item_four_price_number}+${item_five_price_number}
    should be equal as numbers      ${item_total_amount_number}     ${sum_amount}
    ${tax_amount}=   get text    xpath://div[contains(text(), "${shipping_information_locator}")]//following-sibling::div[3]
    ${tax_amount_string}=    Fetch From Right    ${tax_amount}   $
    ${tax_amount_number}=     convert to number    ${tax_amount_string}
    ${total_amount}=  evaluate    ${tax_amount_number}+${sum_amount}
    ${total_amount_on_screen}=   get text    xpath://div[contains(text(), "${shipping_information_locator}")]//following-sibling::div[4]
    ${total_amount_on_screen_string}=    Fetch From Right    ${total_amount_on_screen}   $
    ${total_amount_on_screen_number}=     convert to number    ${total_amount_on_screen_string}
    should be equal as numbers      ${total_amount_on_screen_number}    ${total_amount}

Verify Checkout step three
    click element   xpath://button[contains(text(), "${button_text_finish}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${checkout_page_three_title}")]
    page should contain image        xpath://h2[contains(text(), "${thank_yuu_text_locator}")]/parent::div/img
#    element should not be visible    xpath://a[@class="shopping_cart_link"]//span
    click element   //button[contains(text(), "${button_text_back_home}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${inventory_page_title}")]
#    element should not be visible    xpath://a[@class="shopping_cart_link"]//span

Verify Logout
    click element   xpath://button[contains(text(), "${sidebar_locator}")]
    wait until element is visible   xpath://a[contains(text(), "${logout_option}")]
    click element   xpath://a[contains(text(), "${logout_option}")]
    element should be visible    xpath://div[@class="${logo_locator}"]

*** Keywords ***
verify cart item quantity, title, description, price
    [Arguments]     ${ItemTitle}    ${ItemDescription}      ${ItemPrice}
    element should be visible    xpath://div[contains(text(), "${ItemTitle}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../div[contains(text(), "${ItemDescription}")]
    ${price}=   get text    xpath://div[contains(text(), "${ItemTitle}")]/../..//div[contains(text(), "$")]
    ${ItemPrice}=   Strip String    ${ItemPrice}
    should be equal as strings    ${price}  ${ItemPrice}
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../../div[contains(text(), "1")]
    set browser implicit wait    5s