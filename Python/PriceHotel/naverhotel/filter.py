from jsonpath_ng.ext import parse #extension parser for JSONPath implementation
import pandas as pd
def combine_list(x):
    if isinstance(x,list):
        y=",".join(x)
    else:
        y=x
    return y

def filter_data(res):
    p1=parse("$..rates[*].hcHotelId")
    p2=parse("$..rates[*].otaCode")
    p3=parse("$..rates[*].availableRoomCnt")
    p4=parse("$..rates[*].totalRate")
    p5=parse("$..rates[*].promotionTotalRate")
    p6=parse("$..rates[*].promotionBenefitRate")
    p7=parse("$..rates[*].promotionBenefitType")
    p8=parse("$..rates[*].promotionBenefitValue")
    p9=parse("$..rates[*].roomCategories")
    output=pd.DataFrame({
        "hcHotelId":[i.value for i in p1.find(res)],
        "otaCode":[i.value for i in p2.find(res)],
        "availableRoomCnt":[i.value for i in p3.find(res)],
        "totalRate":[i.value for i in p4.find(res)],
        "promotionTotalRate":[i.value for i in p5.find(res)],
        "promotionBenefitRate":[i.value for i in p6.find(res)],
        "promotionBenefitType":[i.value for i in p7.find(res)],
        "promotionBenefitValue":[i.value for i in p8.find(res)],
        "roomCategories":[combine_list(i.value) for i in p9.find(res)],
    })
    return output