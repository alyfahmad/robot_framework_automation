*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    OperatingSystem
Variables     ../TestData/CommonLocators.py
Variables    ../TestData/LoginPageLocators.py
Variables    ../TestData/ButtonLocators.py
Variables    ../TestData/CheckoutPageLocators.py

*** Variables ***
${standard_username}
${locked_out_username}
${password}

${item_title}
${item_description}
${item_price}
${number_of_items}





*** Test Cases ***
Verify Swag Labs Page Title Logo & Mascot
    open browser and maximize browser window
    Title Should Be     ${page_title}
    Page Should Contain Element   xpath://div[@class="login_logo"]
    Page Should Contain Element   xpath://div[@class="bot_column"]

Login Test with No Credentials
    click element   xpath://input[@value="Login"]
    element should be visible   xpath://h3[contains(text(), "Username is required")]
    click element       xpath://h3[contains(text(), "Username is required")]/button
    element should not be visible   xpath://h3[contains(text(), "Username is required")]
    input text    xpath://input[@placeholder="Username"]    tester
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "Password is required")]
    click element       xpath://h3[contains(text(), "Password is required")]/button
    element should not be visible   xpath://h3[contains(text(), "Password is required")]

Login Test with Invalid Credentials
    input text    xpath://input[@placeholder="Username"]    ${invalid_username}
    input text    xpath://input[@placeholder="Password"]    ${invalid_password}
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "Username and password do not match any user in this service")]
    click element       xpath://h3[contains(text(), "Username and password do not match any user in this service")]/button
    element should not be visible   xpath://h3[contains(text(), "Username and password do not match any user in this service")]

Read and Store Usernames and Password
    ${username_text}=    get text    xpath://div/h4[contains(text(), "Accepted usernames are:")]//parent::div
    ${username_text_split}=     split string    ${username_text}    \n
    set global variable     ${standard_username}    ${username_text_split}[1]
    set global variable     ${locked_out_username}    ${username_text_split}[2]
    ${password_text}=    get text    xpath://div/h4[contains(text(), "Password for all users:")]//parent::div
    ${password_text_split}=     split string    ${password_text}    \n
    set global variable     ${password}    ${password_text_split}[1]

Login Test with Locked Out Credentials
    input text    xpath://input[@placeholder="Username"]    ${locked_out_username}
    input text    xpath://input[@placeholder="Password"]    ${password}
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "Sorry, this user has been locked out.")]
    click element       xpath://h3[contains(text(), "Sorry, this user has been locked out.")]/button
    element should not be visible   xpath://h3[contains(text(), "Sorry, this user has been locked out.")]

Login Test with Valid Credentials
    input text    xpath://input[@placeholder="Username"]    ${standard_username}
    input text    xpath://input[@placeholder="Password"]    ${password}
    click element   xpath://input[@value="${button_text_login}"]

Read Data from Excel and Store
    ${item_title_temp}   ${item_description_temp}     ${item_price_temp}   Read Inventory Data From CSV File and Return List
    set global variable     ${item_title}    ${item_title_temp}
    set global variable     ${item_description}    ${item_description_temp}
    set global variable     ${item_price}    ${item_price_temp}
    ${number_of_items_temp}=    get length  ${item_title}
    set global variable     ${number_of_items}    ${number_of_items_temp}

Verify Inventory Item Image, Title, Description and Price
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Products")]
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        verify image, title, description, price of inventory item   ${item_title}[${product_no}]   ${item_description}[${product_no}]     ${item_price}[${product_no}]
    END

Click on Inventory Production Title and Verify Image, Title, Description, Price
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        click on product title and verify image, title, description and price   ${item_title}[${product_no}]   ${item_description}[${product_no}]     ${item_price}[${product_no}]
    END


Ascending Sorting Check
    click element   xpath://select/option[contains(text(), "Name (A to Z)")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{first_letter_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${first_letter_temp}=   get first letter of inventory items    ${item_title}[0]   ${index}
        append to list    ${first_letter_list}      ${first_letter_temp}
    END
    @{copy_first_letter_list}=  copy list    ${first_letter_list}
    sort list    ${copy_first_letter_list}
    lists should be equal    ${copy_first_letter_list}      ${first_letter_list}

Descending Sorting Chack
    click element   xpath://select/option[contains(text(), "Name (Z to A)")]
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

Price Low to High Sorting Chack
    click element   xpath://select/option[contains(text(), "Price (low to high)")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{price_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${price_list_temp}=   get price of inventory items    ${item_title}[0]   ${index}
        append to list    ${price_list}      ${price_list_temp}
    END
    @{copy_price_list}=  copy list    ${price_list}
    ${sorted_copy_price_list}=  evaluate    sorted(${copy_price_list}, key=float)
    lists should be equal    ${price_list}      ${sorted_copy_price_list}

Price High to Low Sorting Chack
    click element   xpath://select/option[contains(text(), "Price (high to low)")]
    ${inventory_item_count}=    Get Element Count   xpath://div[contains(text(), "${item_title}[0]")]/../../../../../div
    @{price_list}    create list
    FOR    ${index}     IN RANGE    1   ${inventory_item_count}+1
        ${price_list_temp}=   get price of inventory items    ${item_title}[0]   ${index}
        append to list    ${price_list}      ${price_list_temp}
    END
    @{copy_price_list}=  copy list    ${price_list}
    ${sorted_copy_price_list}=  evaluate    sorted(${copy_price_list}, key=float, reverse=True)
    lists should be equal    ${price_list}      ${sorted_copy_price_list}

Add Items to Cart
    FOR    ${product_no}     IN RANGE    ${number_of_items}
        add item to cart and verify button text change   ${item_title}[${product_no}]
    END
    element should be visible    xpath://a[@class="shopping_cart_link"]//span[contains(text(), "6")]

Remove Items from Cart
    remove item from cart and verify button text change    ${item_title}[5]
    remove item from cart and verify button text change    ${item_title}[1]
    element should be visible    xpath://a[@class="shopping_cart_link"]//span[contains(text(), "4")]

Verify Add and Remove Item from Cart from Item Details
    click element   xpath://div[contains(text(), "${item_title}[0]")]
    element should be visible       xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_remove_from_cart}")]
    click element   xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_remove_from_cart}")]
    element should be visible       xpath://div[contains(text(), "${item_title}[0]")]/../button[contains(text(), "${button_text_add_to_cart}")]
    element should be visible    xpath://a[@class="shopping_cart_link"]//span[contains(text(), "3")]
    click element   xpath://button[contains(text(), "${button_text_back_to_products}")]
    element should be visible   xpath://div[contains(text(), "${item_title}[0]")]/../../following-sibling::div//button[contains(text(), "${button_text_add_to_cart}")]
    element should be visible    xpath://a[@class="shopping_cart_link"]//span[contains(text(), "3")]

Verify Cart Items
    click element   xpath://a[@class="shopping_cart_link"]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Your Cart")]
    verify cart item quantity, title, description, price   ${item_title}[2]   ${item_description}[2]     ${item_price}[2]
    verify cart item quantity, title, description, price   ${item_title}[3]   ${item_description}[3]     ${item_price}[3]
    verify cart item quantity, title, description, price   ${item_title}[4]   ${item_description}[4]     ${item_price}[4]

Verify Remove From Cart
    click element   xpath://div[contains(text(), "${item_title}[2]")]/../..//button[contains(text(), "${button_text_remove_from_cart}")]
    set browser implicit wait    5s
#    wait until page does not contain element    xpath://div[contains(text(), "${item_three_title}")]
    ${cart_items_count}=    get element count    xpath://div[contains(text(), "${item_title}[3]")]/../../../../div[@class="cart_item"]
    ${cart_item_count_in_icon}=     get text    xpath://a[@class="shopping_cart_link"]/span
    ${cart_item_count_in_icon}=     convert to integer      ${cart_item_count_in_icon}
    should be equal     ${cart_items_count}     ${cart_item_count_in_icon}
    element should be visible    xpath://a[@class="shopping_cart_link"]//span[contains(text(), "2")]

Checkout step one and enter information
    click element   xpath://button[contains(text(), "${button_text_checkout}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Checkout: Your Information")]
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "First Name is required")]
    input text      xpath://input[@placeholder="First Name"]      Automated
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "Last Name is required")]
    input text      xpath://input[@placeholder="Last Name"]      Bot
    click element   xpath://input[@value="${button_text_continue}"]
    element should be visible   xpath://h3[contains(text(), "Postal Code is required")]
    input text      xpath://input[@placeholder="Zip/Postal Code"]      996633

Chackout step two
    click element   xpath://input[@value="${button_text_continue}"]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Checkout: Overview")]
    verify cart item quantity, title, description, price   ${item_title}[3]   ${item_description}[3]     ${item_price}[3]
    verify cart item quantity, title, description, price   ${item_title}[4]   ${item_description}[4]     ${item_price}[4]
    ${payment_information_temp}=     get text   xpath://div[contains(text(), "Payment Information")]//following-sibling::div[1]
    should be equal as strings      ${payment_information_temp}     ${payment_information}
    ${shipping_information_temp}=   get text   xpath://div[contains(text(), "Shipping Information")]//following-sibling::div[1]
    should be equal as strings      ${shipping_information_temp}     ${shipping_information}
    ${item_total}=   get text    xpath://div[contains(text(), "Shipping Information")]//following-sibling::div[2]
    ${item_total_amount_string}=    Fetch From Right    ${item_total}   $
    ${item_total_amount_number}=     convert to number    ${item_total_amount_string}
    ${item_four_price_number}=      remove string    ${item_price}[3]    $
    ${item_four_price_number}=     convert to number    ${item_four_price_number}
    ${item_five_price_number}=      remove string    ${item_price}[4]    $
    ${item_five_price_number}=     convert to number    ${item_five_price_number}
    ${sum_amount}=  evaluate    ${item_four_price_number}+${item_five_price_number}
    should be equal as numbers      ${item_total_amount_number}     ${sum_amount}
    ${tax_amount}=   get text    xpath://div[contains(text(), "Shipping Information")]//following-sibling::div[3]
    ${tax_amount_string}=    Fetch From Right    ${tax_amount}   $
    ${tax_amount_number}=     convert to number    ${tax_amount_string}
    ${total_amount}=  evaluate    ${tax_amount_number}+${sum_amount}
    ${total_amount_on_screen}=   get text    xpath://div[contains(text(), "Shipping Information")]//following-sibling::div[4]
    ${total_amount_on_screen_string}=    Fetch From Right    ${total_amount_on_screen}   $
    ${total_amount_on_screen_number}=     convert to number    ${total_amount_on_screen_string}
    should be equal as numbers      ${total_amount_on_screen_number}    ${total_amount}

Checkout step three
    click element   xpath://button[contains(text(), "${button_text_finish}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Checkout: Complete!")]
    page should contain image        xpath://h2[contains(text(), "THANK YOU FOR YOUR ORDER")]/parent::div/img
#    element should not be visible    xpath://a[@class="shopping_cart_link"]//span
    click element   //button[contains(text(), "${button_text_back_home}")]
    Wait Until Page Contains Element    xpath://div//span[contains(text(), "Products")]
#    element should not be visible    xpath://a[@class="shopping_cart_link"]//span

Verify logout
    click element   xpath://button[contains(text(), "Open Menu")]
    click element   xpath://a[contains(text(), "Logout")]
    Page Should Contain Element   xpath://div[@class="login_logo"]
    Page Should Contain Element   xpath://div[@class="bot_column"]


Close browser and clear session
    close browser

*** Keywords ***
open browser and maximize browser window
    open browser    ${url}  ${browser}
    maximize browser window

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

add item to cart and verify button text change
    [Arguments]    ${ItemTitle}
    click element   xpath://div[contains(text(), "${ItemTitle}")]/../../following-sibling::div//button[contains(text(), "${button_text_add_to_cart}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../following-sibling::div//button[contains(text(), "${button_text_remove_from_cart}")]
    set browser implicit wait    5s

remove item from cart and verify button text change
    [Arguments]    ${ItemTitle}
    click element   xpath://div[contains(text(), "${ItemTitle}")]/../../following-sibling::div//button[contains(text(), "${button_text_remove_from_cart}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../following-sibling::div//button[contains(text(), "${button_text_add_to_cart}")]
    set browser implicit wait    5s

verify cart item quantity, title, description, price
    [Arguments]     ${ItemTitle}    ${ItemDescription}      ${ItemPrice}
    element should be visible    xpath://div[contains(text(), "${ItemTitle}")]
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../div[contains(text(), "${ItemDescription}")]
    ${price}=   get text    xpath://div[contains(text(), "${ItemTitle}")]/../..//div[contains(text(), "$")]
    ${ItemPrice}=   Strip String    ${ItemPrice}
    should be equal as strings    ${price}  ${ItemPrice}
    element should be visible   xpath://div[contains(text(), "${ItemTitle}")]/../../../div[contains(text(), "1")]
    set browser implicit wait    5s

Read Inventory Data From CSV File and Return List
    ${csvfile}  get file    TestData/inventory.csv
    @{initial_list}   create list    ${csvfile}
    @{modified_list}    split to lines    @{initial_list}   1   #remove header and split to rows
    @{item_title}       create list
    @{item_description}     create list
    @{item_price}       create list
    FOR    ${item}  IN    @{modified_list}
        @{separated_list}    split string    ${item}     |  #split to columns
        append to list  ${item_title}   ${separated_list}[0]
        append to list  ${item_description}   ${separated_list}[1]
        append to list  ${item_price}   ${separated_list}[2]
   END
   return from keyword    ${item_title}     ${item_description}     ${item_price}

