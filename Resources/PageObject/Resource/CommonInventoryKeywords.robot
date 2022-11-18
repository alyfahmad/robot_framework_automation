*** Settings ***
Library    SeleniumLibrary
Library    String
Variables    ../Locators/ButtonLocators.py

*** Keywords ***
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