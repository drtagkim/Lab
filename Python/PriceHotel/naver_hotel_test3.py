#author: taekyung kim
#test update: 2022-09-23

import yaml
import asyncio
from jsonpath_ng.ext import parse #extension parser for JSONPath implementation
from playwright.async_api import async_playwright,TimeoutError
from time import process_time
from datetime import timedelta
#Modele
from naverhotel.filter import filter_data
from naverhotel.model import OutputData
from naverhotel.util_network import build_url
from naverhotel.util_list import list_split
'''
Settings ============================================
'''
YAML_INPUT="input.yaml"
TEMP_DIR='./temp'
HEADLESS=True
N=14
'''
Run process =========================================
'''
async def run_process(browser,url,fout_file,time_span):
    async def handle_response(response):
            if 'https://hotel-api.naver.com/graphql' in response.url:
                try:
                    response_data=await response.json()
                    p=parse("$..rates") #discover top rates
                    m=p.find(response_data)
                    if len(m)>0:
                        df=OutputData(url,fout_file,time_span)
                        df.df=filter_data(response_data)
                        df.write()
                        #print("hit") #test
                except:
                    pass
    page1=await browser.new_page()
    page1.on('response',handle_response)
    tracking=0
    while True:
        tracking+=1
        try:
            await page1.goto(url,wait_until='commit',timeout=1000*30) #30 seconds
            break
        except TimeoutError:
            assert tracking<10,"Too many trials"
            continue
    await page1.wait_for_timeout(2000)
    await page1.wait_for_load_state("networkidle")
'''
Run Main =========================================================
'''
async def run_main(browser,fout_file,url,res_wait=500,time_span=0,offset=0):
    url=build_url(url,time_span,offset) #build url
    await run_process(browser,url,fout_file,time_span)
async def main(fout_file,url,res_wait,days):
    days_list=list(range(days))
    days_splitted=list_split(days_list,N)
    end_k=0
    for item in days_splitted:
        async with async_playwright() as playwright:
            browser=await playwright.chromium.launch_persistent_context(user_data_dir=TEMP_DIR,headless=HEADLESS)
            tasks=[]
            print(f"{fout_file}")
            print(item[0]+1,end=' ')
            for i in item:
                if i is not None:
                    end_k=i
                    print(f".",end='')
                    tasks.append(
                        asyncio.create_task(run_main(browser,fout_file,url,res_wait,i))
                    )
            await asyncio.wait(tasks)
            await browser.close()
            print(end_k+1)
if __name__=="__main__":
    #open file
    start_t=process_time()
    with open(YAML_INPUT) as f:
        settings=yaml.load(f,Loader=yaml.FullLoader)
    assert "setting" in settings,"Setting should be!"
    #settings
    fout_file=settings['setting']['foutfile']
    url=settings['setting']['url']
    res_wait=settings['setting']['res_wait']
    days=settings['setting']['days']
    #run
    asyncio.run(main(fout_file,url,res_wait,days))
    print("OK.")
    end_t=process_time()
    print(f'Process time: {timedelta(seconds=end_t-start_t)}')
    print(f'End of testing. Thank you.')
# ==== END OF PROGRAM ====