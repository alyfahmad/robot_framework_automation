
# Robot Framework & Selenium Test Automation

Hi. This is a practice automation project using Robot Framework and Selenium.

- To Prepare the environment please refer to the [Environment Setup Guide](#Environment Setup Guide).
- You can run the automated tests using the executor.bat file.
## Covered Test Cases

> - Login Page
>>    - Verify Logo of Swaglabs
>>    - Verify Swaglabs Mascot
>>   - Verify Login with Invalid User
>>    - Verify Error Messages
>>    - Verify login with Locked out User
>>    - Verify login with Valid User
> - Inventory Page
>>    - Read Inventory Item information from csv
>>    - Verify Inventory Item Images
>>    - Verify Inventory Item Titles
>>    - Verify Inventory Item Descriptions
>>    - Verify Inventory Item Prices
>>   - Click on each item and validate navigation
>>    - Verify Intenvory Item Images from details page
>>    - Verify Intenvory Item Titles from details page
>>    - Verify Intenvory Item Descriptions from details page
>>    - Verify Intenvory Item Prices from details page
>>    - Verify A to Z Sorting
>>    - Verify Z to A Sorting
>>    - Verify Price High to Low Sorting
>>    - Verify Price Low to High Sorting
> - Cart Page
>>    - Verify Adding Items to Cart
>>    - Verify Removing Items from Cart
>>    - Verify Button Text Change and Functionality
>>    - Verify Adding Items to Cart from details page
>>    - Verify Removing Items from Cart from details page
>>    - Verify Button Text Change and Functionality on details page
>>    - Verify Item count on cart icon
>>    - Verify Item Titles on Cart
>>    - Verify Item Descriptions on Cart
>>    - Verify Item Prices on Cart
>>    - Verify Item Quantity on Cart
>>    - Verify Removing items from Cart from the Cart Page
> - Checkout page
>>    - Verify FirstName for Checkout
>>    - Verify LastName for Checkout
>>    - Verify PostalCode for Checkout
>>    - Verify Error Messages
>>    - Verify Item Title on Checkout Page
>>    - Verify Item Description on Checkout Page
>>    - Verify Item Price on Checkout Page
>>    - Verify Item Quantity on Checkout Page
>>    - Verify Shipping information
>>    - Verify Payment information
>>    - Verify Calculation of Item Total
>>    - Verify Calculation of Total
>>   - Verify Thank You Page
>>   - Verify Logout

## Acknowledgements

 - I used a great test website by Sauce Labs for this automation: https://www.saucedemo.com/


## Environment Setup Guide 

1. Install the latest version(3.11.0) of python from https://www.python.org/
2. check python installation by opening the command prompt and typing in "python --version"
3. Open properties of your pc (Go to this pc and right click select properties)
4. Go to environment variables → Select Path variable →  Click on edit
5. Add the python scripts path to environment variables
6. Check pip installation by opening the command prompt and typing in "pip --version"
7. Install selenium by typing in "pip install selenium"
8. Install robotframework by typing in "pip install robotframework"
9. Install robotframework-seleniumlibrary by typing in "pip install robotframework-seleniumlibrary"
10. Install Pycharm IDE
11. Create a new project
12. Go to File →  Settings
13. Select the project and go to python interpreter
14. Add 3 interpreters - (1) selenium (2)robotframework (3)robotframework-seleniumlibrary
15. Add plugin for IntelliBot Patched (optional but recommended)
16. Download selenium driver for chrome from "https://chromedriver.chromium.org/downloads"
17. Unzip the file and place the .exe file in the scripts folder of your python installation

__Good to Know:__  Remember to use the correct location for python interpreter. If you're configuring locally then use that otherwise
use the global configuration

