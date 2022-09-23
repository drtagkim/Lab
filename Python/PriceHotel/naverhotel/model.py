from os.path import exists
from .util_date import pick_date_from_today
from .writer import write_data_to_excel

class OutputData:
    def __init__(self,url,fout_file,time_span):
        self.df=None
        self.url=url
        self.checked=False
        self.fout_file=fout_file
        self.time_span=time_span
    def write(self):
        url=self.url
        today=pick_date_from_today()
        pickDate=pick_date_from_today(self.time_span)
        self.df['url']=url
        self.df['today']=today
        self.df['pickDate']=pickDate
        if not exists(self.fout_file):
            self.df.to_excel(self.fout_file,index=False)
        else:
            write_data_to_excel(self.df,self.fout_file)