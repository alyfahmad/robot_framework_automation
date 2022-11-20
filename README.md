
# Robot Framework & Selenium Test Automation

Hi. This is a practice automation project using Robot Framework and Selenium.

- To Prepare the environment please refer to the [Environment Setup Guide](#environment-setup-guide).
- You can run the automated tests using the executor.bat file.
## Covered Test Cases

<details>
  <summary>Login Page</summary>
  <ul>
   <li>Verify Logo of Swaglabs</li>
   <li>Verify Swaglabs Mascot</li>
   <li>Verify Login with Invalid User</li>
   <li>Verify Error Messages</li>
   <li>Verify login with Locked out User</li>
   <li>Verify login with Valid User</li>
  </ul>
</details>
<details>
  <summary>Inventory Page</summary>
  <ul>
   <li>Read Inventory Item information from csv</li>
   <li>Verify Inventory Item Images</li>
   <li>Verify Inventory Item Titles</li>
   <li>Verify Inventory Item Descriptions</li>
   <li>Verify Inventory Item Prices</li>
   <li>Click on each item and validate navigation</li>
   <li>Verify Intenvory Item Images from details page</li>
   <li>Verify Intenvory Item Titles from details page</li>
   <li>Verify Intenvory Item Descriptions from details page</li>
   <li>Verify Intenvory Item Prices from details page</li>
   <li>Verify A to Z Sorting</li>
   <li>Verify Z to A Sorting</li>
   <li>Verify Price High to Low Sorting</li>
   <li>Verify Price Low to High Sorting</li>
  </ul>
</details>
<details>
  <summary>Cart Page</summary>
  <ul>
   <li>Verify Adding Items to Cart</li>
   <li>Verify Removing Items from Cart</li>
   <li>Verify Button Text Change and Functionality</li>
   <li>Verify Adding Items to Cart from details page</li>
   <li>Verify Removing Items from Cart from details page</li>
   <li>Verify Button Text Change and Functionality on details page</li>
   <li>Verify Item count on cart icon</li>
   <li>Verify Item Titles on Cart</li>
   <li>Verify Item Descriptions on Cart</li>
   <li>Verify Item Prices on Cart</li>
   <li>Verify Item Quantity on Cart</li>
   <li>Verify Removing items from Cart from the Cart Page</li>
  </ul>
</details>
<details>
  <summary>Checkout page</summary>
  <ul>
   <li>Verify FirstName for Checkout</li>
   <li>Verify LastName for Checkout</li>
   <li>Verify PostalCode for Checkout</li>
   <li>Verify Error Messages</li>
   <li>Verify Item Title on Checkout Page</li>
   <li>Verify Item Description on Checkout Page</li>
   <li>Verify Item Price on Checkout Page</li>
   <li>Verify Item Quantity on Checkout Page</li>
   <li>Verify Shipping information</li>
   <li>Verify Payment information</li>
   <li>Verify Calculation of Item Total</li>
   <li>Verify Calculation of Total</li>
   <li>Verify Thank You Page</li>
   <li>Verify Logout</li>
  </ul>
</details> 




## Demo Video
[demp](https://user-images.githubusercontent.com/61960249/202766257-d3e6509b-15f1-4606-ad9d-9b9f83ea8899.mp4)

## Acknowledgements

 - I used a great test website by Sauce Labs for this automation: https://www.saucedemo.com/
 - Robot Framework Documentations
    - SeleniumLibrary: https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
    - String: https://robotframework.org/robotframework/latest/libraries/String.html
    - Collections: https://robotframework.org/robotframework/latest/libraries/Collections.html
    - OperatingSystem: https://robotframework.org/robotframework/latest/libraries/OperatingSystem.html

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

