from selenium import webdriver

driver = webdriver.Edge()
driver.get('https://www.element3ds.com/portal.php')

print(driver.title)
driver.quit()