from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.edge.options import Options

option = Options()
option.add_argument('--headless')#隐式
option.add_argument('window-size=1920x1080')#headless状态下分辨率是0x0,需要修改下.

option.add_argument("--start-maximized")#初始窗口状态就最大化
option.add_argument('--incognito')#浏览器无痕
option.add_argument('--disable-infobars')#禁用浏览器自动化提示
#关于add_argument其他参数:https://peter.sh/experiments/chromium-command-line-switches/

driver = webdriver.Edge(options=option)

driver.set_page_load_timeout(5)
try:
    driver.get('https://www.element3ds.com/portal.php')
except Exception as message:
    print("5秒内未加载完成,强制停止加载,继续执行下去")
    driver.execute_script("window.stop()")
driver.find_element(by = By.CLASS_NAME, value="top_login").click()
print("已点top_login")

driver.quit()