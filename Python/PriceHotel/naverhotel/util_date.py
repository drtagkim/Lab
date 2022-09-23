from datetime import timedelta
import datetime

def pick_date_from_today(delta=0):
    t=datetime.date.today()
    t1=t+timedelta(days=delta) #하루를 더한다.
    return t1.strftime("%Y-%m-%d")
