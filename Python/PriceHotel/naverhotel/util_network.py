from .util_date import pick_date_from_today
def build_url(url,time_span,offset=0):
    url+="&adultCnt=2"
    url+=f"&checkIn={pick_date_from_today(time_span+offset)}"
    url+=f"&checkOut={pick_date_from_today(time_span+offset+1)}"
    return url