*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    OperatingSystem
Variables     ../Locators/CommonLocators.py

*** Keywords ***
open browser and maximize browser window
    open browser    ${url}      ${browser}
    maximize browser window

close browser and clear session
    close browser

Read Inventory Data From CSV File and Return List
    ${csvfile}  get file    Resources/PageObject/TestData/inventory.csv
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