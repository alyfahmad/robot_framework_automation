*** Settings ***
Library    SeleniumLibrary
Library    String
#Library    DataDriver   ..\..\TestData\inventory.xls    sheet_name=Sheet1

*** Variables ***
${browser}      chrome
${url}      https://www.saucedemo.com/
${page_title}       Swag Labs
${invalid_username}     tester
${invalid_password}     password
${standard_username}
${locked_out_username}
${password}
${item_one_title}       Sauce Labs Backpack
${item_one_description}    carry.allTheThings() with the sleek, streamlined Sly Pack that melds uncompromising style with unequaled laptop and tablet protection.
${item_one_price}       $29.99


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
    click element   xpath://input[@value="Login"]
    element should be visible   xpath://h3[contains(text(), "Password is required")]
    click element       xpath://h3[contains(text(), "Password is required")]/button
    element should not be visible   xpath://h3[contains(text(), "Password is required")]

Login Test with Invalid Credentials
    input text    xpath://input[@placeholder="Username"]    ${invalid_username}
    input text    xpath://input[@placeholder="Password"]    ${invalid_password}
    click element   xpath://input[@value="Login"]
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
    click element   xpath://input[@value="Login"]
    element should be visible   xpath://h3[contains(text(), "Sorry, this user has been locked out.")]
    click element       xpath://h3[contains(text(), "Sorry, this user has been locked out.")]/button
    element should not be visible   xpath://h3[contains(text(), "Sorry, this user has been locked out.")]

Login Test with Valid Credentials
    input text    xpath://input[@placeholder="Username"]    ${standard_username}
    input text    xpath://input[@placeholder="Password"]    ${password}
    click element   xpath://input[@value="Login"]

Verify Inventory Item Image, Title, Description and Price
    verify image, title, description, price of inventory item   ${item_one_title}   ${item_one_description}     ${item_one_price}


Close browser and clear session
    close browser

*** Keywords ***
open browser and maximize browser window
    open browser    ${url}  ${browser}
    maximize browser window

verify image, title, description, price of inventory item
    [Arguments]     ${ItemTitle}    ${ItemDescription}      ${ItemPrice}
    Wait Until Page Contains Element    xpath://div[@class="peek"]
    page should contain image    xpath://div[contains(text(), "Sauce Labs Backpack")]//parent::a//parent::div//preceding::div[1]/a/img
    element should be visible    xpath://div[contains(text(), "${ItemTitle}")]
    element should be visible   xpath://div[contains(text(), "Sauce Labs Backpack")]//parent::a//parent::div//div[contains(text(), "${ItemDescription}")]
    ${price}=   get text    xpath://div[contains(text(), "Sauce Labs Backpack")]//parent::a//parent::div//parent::div//div[contains(text(), "$")]
    should be equal as strings    ${price}  ${ItemPrice}




