import time
import Account
import mail
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.edge.options import Options

def webClass():
    option = Options()
    option.add_argument('--headless')#隐式
    option.add_argument('window-size=1920x1080')#headless状态下分辨率是0x0,需要修改下.

    option.add_argument("--start-maximized")  # 初始窗口状态就最大化
    option.add_argument('--incognito')  # 浏览器无痕
    option.add_argument('--disable-infobars')  # 禁用浏览器自动化提示
    # 关于add_argument其他参数:https://peter.sh/experiments/chromium-command-line-switches/
    # option.page_load_strategy = 'eager' #https://zhuanlan.zhihu.com/p/453590557

    driver = webdriver.Edge(options=option)

    # driver.set_page_load_timeout(10)
    # try:
    #     driver.get('https://www.element3ds.com/portal.php')
    # except Exception as message:
    #     print("7秒内未加载完成,强制停止加载,继续执行下去")
    #     driver.execute_script("window.stop()")
    driver.get('https://www.element3ds.com/portal.php')

    driver.find_element(By.XPATH, '//header/nav[1]/div[4]/div[1]/ul[1]/li[1]/a[2]').click()  # 登陆点击
    time.sleep(1)
    driver.find_element(By.XPATH, "//input[@type='text' and@placeholder='请输入您的用户名']").send_keys(Account.username)
    time.sleep(1)
    driver.find_element(By.XPATH, "//input[@type='password' and@placeholder='请输入密码']").send_keys(Account.password)
    time.sleep(1)

    driver.find_element(By.XPATH, '//tbody/tr[1]/td[1]/button[1]/strong[1]').click()  # 登陆确认
    time.sleep(5)

    #摇奖页面
    driver.get('https://www.element3ds.com/plugin.php?id=yinxingfei_zzza:yinxingfei_zzza_hall')
    time.sleep(1)
    driver.find_element(By.XPATH, "//a[contains(text(),'可以摇奖')]").click()
    time.sleep(1)
    driver.find_element(By.XPATH, "//a[contains(text(),'我知道了')]").click()
    time.sleep(2)
    driver.find_element(By.XPATH, "//a[@ id = 'zzza_go']").click()#摇奖完成
    time.sleep(5)

    #矿场
    driver.get('https://www.element3ds.com/plugin.php?id=yw_mine:front&mod=mineDetail&mineId=183')
    time.sleep(1)
    IssuanceQuantity = driver.find_element(By.XPATH,"//body[1]/div[4]/div[2]/div[1]/div[1]/div[2]/div[2]/div[1]/div[1]/div[2]/div[1]/div[3]").text

    if driver.find_elements(By.XPATH, "//a[contains(text(),'开始挖矿')]"):
        allore = int(driver.find_element(By.XPATH,"//body[1]/div[4]/div[2]/div[1]/div[1]/div[2]/div[2]/div[1]/div[1]/div[2]/div[3]/div[1]/span[2]").text)
        if allore>0:
            driver.find_element(By.XPATH, "//a[contains(text(),'领取矿石')]").click()
            time.sleep(1)
            driver.find_element(By.XPATH, "//tbody/tr[2]/td[2]/div[1]/div[1]/form[1]/div[2]/input[1]").click()
            time.sleep(1)
            driver.find_element(By.XPATH, "//input[@id='enter']").click()
            time.sleep(1)

        driver.find_element(By.XPATH, "//a[contains(text(),'开始挖矿')]").click()
        time.sleep(1)
        driver.find_element(By.XPATH, "//body/b[1]/div[3]/div[2]/div[4]/a[1]").click()
        time.sleep(1)
        driver.find_element(By.XPATH, " //a[contains(text(),'确定')]").click()
        time.sleep(1)

        mail.main(IssuanceQuantity)
        driver.quit()

    else:
        mail.main(IssuanceQuantity+"未找到挖矿元素!")
        driver.quit()

webClass()




