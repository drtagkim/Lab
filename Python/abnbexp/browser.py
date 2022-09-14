#pip install PyQtWebEngine
#pip install PyQt5

import sys,time
from bs4 import BeautifulSoup as BS
from PyQt5.QtCore import QUrl
from PyQt5.QtWebEngineWidgets import QWebEnginePage
from PyQt5.QtWidgets import QApplication
from PyQt5.QtPrintSupport import QPrinter
from PyQt5.QtCore import QTimer
import traceback

  
class Page(QWebEnginePage):
  def __init__(self):
    self.app=QApplication(sys.argv)
    QWebEnginePage.__init__(self)
    self.html=''
    self.loadFinished.connect(self._on_load_finished)
  def navigate(self,url):
    self.load(QUrl(url))
    self.flush()
  def _on_load_finished(self):
    time.sleep(5)
    self.toHtml(self.exe_get_source)
  def exe_get_source(self,html_str):
    self.html=html_str
    self.app.quit()
  def exe_on_error(self):
    print("timeout")
    self.html=''
    self.app.quit()
  def flush(self):
    watchdog = QTimer()
    watchdog.setSingleShot(True)
    watchdog.timeout.connect(lambda : self.exe_on_error())
    watchdog.start(20000) #20 seconds max 
    self.app.exec_() #execute
 
class Abnb:
  page1="https://www.airbnb.com/experiences/661857?currentTab=experience_tab&federatedSearchId=52e4120f-105c-4041-b508-6f56a0268f12&searchId=a9c18c23-ad45-4086-b916-de013d4f8c58&sectionId=0e92da7e-b5d7-488f-a325-356a5819079d&source=p2"
# if __name__=="__main__":
#   #url='https://pythonprogramming.net/parsememcparseface/'
#   url='https://hotels.naver.com/item?hotelFileName=hotel%3AParaspara_Seoul_operated_by_Josun_hotels_Resorts&adultCnt=2&checkIn=2022-07-25&checkOut=2022-07-26'
#   page=Page()
#   print("Page created")
#   page.navigate(url)
#   print('Navigation complete')
#   #soup=BS(page.html,'html5lib')
#   #js_test=soup.find('p',class_='jstest')
#   #print(js_test.text)
#   with open('test.txt','w',encoding='utf-8') as f:
#     f.write(page.html)
#   print('finished.')