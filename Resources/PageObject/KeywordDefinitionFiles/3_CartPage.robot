*** Settings ***
Library    SeleniumLibrary
Resource    ../Resource/CommonKeywords.robot
Resource    ../Resource/CommonInventoryKeywords.robot
Variables    ../Locators/ButtonLocators.py
Variables    ../Locators/CartPageLocators.py

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

Add Items to Cart
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        add item to cart and verify button text change   ${item_title}[${product_no}]
    END
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "6")]

Verify Remove Items from Cart
    remove item from cart and verify button text change    ${item_title}[5]
    remove item from cart and verify button text change    ${item_title}[1]
    remove item from cart and verify button text change    ${item_title}[0]
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "3")]

Verify Cart Items
    click element   xpath://a[@class="${cart_counter_locator}"]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${cart_page_title}")]
    verify cart item quantity, title, description, price   ${item_title}[2]   ${item_description}[2]     ${item_price}[2]
    verify cart item quantity, title, description, price   ${item_title}[3]   ${item_description}[3]     ${item_price}[3]
    verify cart item quantity, title, description, price   ${item_title}[4]   ${item_description}[4]     ${item_price}[4]

Verify Remove From Cart
    click element   xpath://div[contains(text(), "${item_title}[2]")]/../..//button[contains(text(), "${button_text_remove_from_cart}")]
    set browser implicit wait    5s
#    wait until page does not contain element    xpath://div[contains(text(), "${item_three_title}")]
    ${cart_items_count}=    get element count    xpath://div[contains(text(), "${item_title}[3]")]/../../../../div[@class="${cart_item_locator}"]
    ${cart_item_count_in_icon}=     get text    xpath://a[@class="${cart_counter_locator}"]/span
    ${cart_item_count_in_icon}=     convert to integer      ${cart_item_count_in_icon}
    should be equal     ${cart_items_count}     ${cart_item_count_in_icon}
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "2")]

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