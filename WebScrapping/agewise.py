from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import platform
import os
import time
from tqdm import tqdm

def get_browser(driver_path,headless=False):
    options = webdriver.ChromeOptions()
    prefs = {}
    options.add_experimental_option("prefs", prefs)
    options.headless = headless
    if platform.system()=='Windows':
        curr_dir=os.getcwd()
        os.chdir(driver_path)
        browser = webdriver.Chrome(options=options)
        os.chdir(curr_dir)
    else:
        browser = webdriver.Chrome(options=options, executable_path=driver_path)
    return browser

def visit_home_page(browser,url):
    browser.get(url)
    return browser 

def select_radio_button(browser,percent=False):
    css_selector_perc = "#ContentPlaceHolder1_RadioButtonList1_0"
    css_selector_num = "#ContentPlaceHolder1_RadioButtonList1_1"
    if percent:
        css_selector = css_selector_perc
    else:
        css_selector = css_selector_num
    browser.find_element_by_css_selector(css_selector).click()
    return browser

def download_excel(browser):
    css_selector = "#ContentPlaceHolder1_LinkButton1"
    browser.find_element_by_css_selector(css_selector).click()
    return browser

def get_table(browser):
    table = browser.find_element_by_xpath('''//*[@id="form1"]/div[3]/center/table[3]''')
    return browser,table

if __name__=='__main__':
    home_page = 'http://mnregaweb4.nic.in/netnrega/age_reg_emp.aspx?page=s&lflag=eng&state_name=BIHAR&state_code=05&fin_year=2018-2019&source=national&Digest=2aOUkcCldO+XWneoNOSTPA'
    driver_path = "./chromedriver_win32"
    browser = get_browser(driver_path=driver_path,headless=False)
    time.sleep(1)
    browser = visit_home_page(browser,url=home_page)
    browser = select_radio_button(browser,percent=False)
    browser = download_excel(browser)
    time.sleep(1)
    browser,table = get_table(browser)
    for row in tqdm(table.find_elements_by_tag_name("tr")[4:-1]):
        row_values = [i for i in row.find_elements_by_tag_name("td")]
        url = row_values[1].find_element_by_tag_name('a').get_attribute("href")
        b = get_browser(driver_path=driver_path,headless=False)
        time.sleep(1)
        b = visit_home_page(b,url=url)
        b = select_radio_button(b,percent=False)
        b = download_excel(b)
        time.sleep(1)
        b.close()
    browser.close()

