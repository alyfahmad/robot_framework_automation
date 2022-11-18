*** Settings ***
Library    SeleniumLibrary
Resource    ../Resource/CommonKeywords.robot
Variables    ../Locators/LoginPageLocators.py
Variables    ../Locators/ButtonLocators.py
Variables    ../TestData/LoginPageTestData.py

Suite Setup     open browser and maximize browser window
Suite Teardown    close browser and clear session

*** Variables ***
${standard_username}
${locked_out_username}
${password}

*** Test Cases ***
Verify Swag Labs Page Title Logo & Mascot
    title should be     ${page_title}
    page should contain element   xpath://div[@class="${logo_locator}"]
    page should contain element   xpath://div[@class="${bot_locator}"]

Read and Store Usernames and Password
    ${username_text}=    get text    xpath://div/h4[contains(text(), "${accepted_username_locator}")]//parent::div
    ${username_text_split}=     split string    ${username_text}    \n
    set global variable     ${standard_username}    ${username_text_split}[1]
    set global variable     ${locked_out_username}    ${username_text_split}[2]
    ${password_text}=    get text    xpath://div/h4[contains(text(), "${password_locator}")]//parent::div
    ${password_text_split}=     split string    ${password_text}    \n
    set global variable     ${password}    ${password_text_split}[1]

Verify Login With No Credentials
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "${username_required_message}")]
    click element       xpath://h3[contains(text(), "${username_required_message}")]/button
    element should not be visible   xpath://h3[contains(text(), "${username_required_message}")]
    input text    xpath://input[@placeholder="${username_locator}"]    ${invalid_username}
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "${password_required_message}")]
    click element       xpath://h3[contains(text(), "${password_required_message}")]/button
    element should not be visible   xpath://h3[contains(text(), "${password_required_message}")]

Verify Login With Invalid Credentials
    input text    xpath://input[@placeholder="${username_locator}"]    ${invalid_username}
    input text    xpath://input[@placeholder="${password_locator}"]    ${invalid_password}
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "${username_password_mismatch_message}")]
    click element       xpath://h3[contains(text(), "${username_password_mismatch_message}")]/button
    element should not be visible   xpath://h3[contains(text(), "${username_password_mismatch_message}")]

Verify Login With Locked Out Credentials
    input text    xpath://input[@placeholder="${username_locator}"]    ${locked_out_username}
    input text    xpath://input[@placeholder="${password_locator}"]    ${password}
    click element   xpath://input[@value="${button_text_login}"]
    element should be visible   xpath://h3[contains(text(), "${locked_out_user_message}")]
    click element       xpath://h3[contains(text(), "${locked_out_user_message}")]/button
    element should not be visible   xpath://h3[contains(text(), "${locked_out_user_message}")]

Verify Login With Valid Credentials
    input text    xpath://input[@placeholder="${username_locator}"]    ${standard_username}
    input text    xpath://input[@placeholder="${password_locator}"]    ${password}
    click element   xpath://input[@value="${button_text_login}"]
    wait until page contains element    xpath://div//span[contains(text(), "${inventory_page_title}")]

Verify Logout
    click element   xpath://button[contains(text(), "${sidebar_locator}")]
    wait until element is visible   xpath://a[contains(text(), "${logout_option}")]
    click element   xpath://a[contains(text(), "${logout_option}")]
    element should be visible   xpath://div[@class="${logo_locator}"]