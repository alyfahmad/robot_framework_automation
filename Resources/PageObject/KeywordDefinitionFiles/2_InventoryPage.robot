*** Settings ***
Library    SeleniumLibrary
Resource    ../Resource/CommonKeywords.robot
Resource    ../Resource/CommonInventoryKeywords.robot
Variables    ../Locators/ButtonLocators.py
Variables    ../Locators/InventoryPageLocators.py

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

Verify Inventory Item Image, Title, Description and Price
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "${inventory_page_title}")]
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        verify image, title, description, price of inventory item   ${item_title}[${product_no}]   ${item_description}[${product_no}]     ${item_price}[${product_no}]
    END

Verify Click on Inventory Production Title and Verify Image, Title, Description, Price From Details
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        click on product title and verify image, title, description and price   ${item_title}[${product_no}]   ${item_description}[${product_no}]     ${item_price}[${product_no}]
    END

Verify Ascending Sorting Check
    click element   xpath://select/option[contains(text(), "${sorting_option_a_to_z}")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{first_letter_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${first_letter_temp}=   get first letter of inventory items    ${item_title}[0]   ${index}
        append to list    ${first_letter_list}      ${first_letter_temp}
    END
    @{copy_first_letter_list}=  copy list    ${first_letter_list}
    sort list    ${copy_first_letter_list}
    lists should be equal    ${copy_first_letter_list}      ${first_letter_list}

Verify Descending Sorting Chack
    click element   xpath://select/option[contains(text(), "${sorting_option_z_to_a}")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{first_letter_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${first_letter_temp}=   get first letter of inventory items    ${item_title}[0]   ${index}
        append to list    ${first_letter_list}      ${first_letter_temp}
    END
    @{copy_first_letter_list}=  copy list    ${first_letter_list}
    sort list    ${copy_first_letter_list}
    reverse list   ${copy_first_letter_list}
    lists should be equal    ${copy_first_letter_list}      ${first_letter_list}

Verify Price Low to High Sorting Chack
    click element   xpath://select/option[contains(text(), "${sorting_option_low_to_high}")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{price_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${price_list_temp}=   get price of inventory items    ${item_title}[0]   ${index}
        append to list    ${price_list}      ${price_list_temp}
    END
    @{copy_price_list}=  copy list    ${price_list}
    ${sorted_copy_price_list}=  evaluate    sorted(${copy_price_list}, key=float)
    lists should be equal    ${price_list}      ${sorted_copy_price_list}

Verify Price High to Low Sorting Chack
    click element   xpath://select/option[contains(text(), "${sorting_option_high_to_low}")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{price_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${price_list_temp}=   get price of inventory items    ${item_title}[0]   ${index}
        append to list    ${price_list}      ${price_list_temp}
    END
    @{copy_price_list}=  copy list    ${price_list}
    ${sorted_copy_price_list}=  evaluate    sorted(${copy_price_list}, key=float, reverse=True)
    lists should be equal    ${price_list}      ${sorted_copy_price_list}

Verify Add Items to Cart
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        add item to cart and verify button text change   ${item_title}[${product_no}]
    END
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "6")]

Verify Remove Items from Cart
    remove item from cart and verify button text change    ${item_title}[5]
    remove item from cart and verify button text change    ${item_title}[1]
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "4")]

Verify Add and Remove Item from Cart from Item Details
    click element   xpath://div[contains(text(), "${item_title}[0]")]
    element should be visible       xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_remove_from_cart}")]
    click element   xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_remove_from_cart}")]
    element should be visible       xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_add_to_cart}")]
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "3")]
    click element   xpath://button[contains(text(), "${button_text_back_to_products}")]
    element should be visible   xpath://div[contains(text(), "${item_title}[0]")]/../../following-sibling::div//button[contains(text(), "${button_text_add_to_cart}")]
    element should be visible    xpath://a[@class="${cart_counter_locator}"]//span[contains(text(), "3")]

Verify Logout
    click element   xpath://button[contains(text(), "${sidebar_locator}")]
    wait until element is visible   xpath://a[contains(text(), "${logout_option}")]
    click element   xpath://a[contains(text(), "${logout_option}")]
    element should be visible    xpath://div[@class="${logo_locator}"]

*** Keywords ***
verify image, title, description, price of inventory item
    [Arguments]     ${ItemTitle}    ${ItemDescription}      ${ItemPrice}
    wait until page contains element    xpath://div[contains(text(), "${ItemTitle}")]//parent::a//parent::div//preceding::div[1]/a/img
    page should contain image    xpath://div[contains(text(), "${ItemTitle}")]//parent::a//parent::div//preceding::div[1]/a/img
    element should be visible    xpath://div[contains(text(), "${ItemTitle}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]//parent::a//parent::div//div[contains(text(), "${ItemDescription}")]
    ${price}=   get text    xpath://div[contains(text(), "${ItemTitle}")]//parent::a//parent::div//parent::div//div[contains(text(), "$")]
    ${ItemPrice}=   Strip String    ${ItemPrice}
    should be equal as strings    ${price}  ${ItemPrice}
    set browser implicit wait    5s

click on product title and verify image, title, description and price
    [Arguments]     ${ItemTitle}    ${ItemDescription}      ${ItemPrice}
    click element   xpath://div[contains(text(), "${ItemTitle}")]
    wait until page contains element    xpath://div[contains(text(), "${ItemTitle}")]//parent::div//preceding::div[1]/img
    page should contain image    xpath://div[contains(text(), "${ItemTitle}")]//parent::div//preceding::div[1]/img
    element should be visible    xpath://div[contains(text(), "${ItemTitle}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]//parent::div//div[contains(text(), "${ItemDescription}")]
    ${price}=   get text    xpath://div[contains(text(), "${ItemTitle}")]//parent::div//parent::div//div[contains(text(), "$")]
    ${ItemPrice}=   Strip String    ${ItemPrice}
    should be equal as strings    ${price}  ${ItemPrice}
    click element   xpath://button[contains(text(), "${button_text_back_to_products}")]
    set browser implicit wait    5s

get first letter of inventory items
    [Arguments]    ${FirstItemTitle}     ${index}
    ${item_title}=    get text    xpath://div[contains(text(), "${FirstItemTitle}")]/../../../../../div[${index}]
    ${first_letter_of_item}=  get substring    ${item_title}    0   1
    return from keyword    ${first_letter_of_item}

get price of inventory items
    [Arguments]    ${FirstItemTitle}     ${index}
    ${item_price_with_dollar_sign}=    get text    xpath://div[contains(text(), "${FirstItemTitle}")]/../../../../../div[${index}]//div[contains(text(),"$")]
    ${item_price}=  get substring    ${item_price_with_dollar_sign}    1
    return from keyword    ${item_price}