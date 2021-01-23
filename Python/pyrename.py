#file rename
#Taekyung Kim
# ---- MODULES ----
import argparse #argument parser
import os
import pathlib
import glob #list files
import time #time marker
import sys #write IO
# ---- FUNCTIONS ----
def progressBar(value, endvalue, msg="Percent",bar_length=20):
'''
Progress bar
value - current value
endvalue - final value
msg - message
bar_length - number of characters in progress bar
'''
    assert value <=endvalue #assertion
    assert bar_length<=40,"Bar length should be within 40."
    percent = float(value) / endvalue
    arrow = '-' * int(round(percent * bar_length)-1) + '>'
    spaces = ' ' * (bar_length - len(arrow))
    sys.stdout.write("\r{}: [{}] {}%".format(msg,arrow + spaces, int(round(percent * 100))))
    sys.stdout.flush()
def list_files(filetype:str)->list:
'''
List file in current directory
filetype - file extension like png, jpg, pdf,...
'''
    assert len(filetype)>0,"File extension length should be more than 1"
    files=glob.glob("*.%s"%(filetype,))
    return files
def get_today()->str:
'''
Create time marker (2021-01-22 for instance)
'''
    t=time.localtime(time.time())
    return time.strftime('%Y-%m-%d',t)
def rename_files(inputfiles:list,istoday:bool):
'''
Rename files
inputfiles - input file (list)
istoday - bool, adding a today marker
'''
    if istoday:
        prefix=get_today()
    else:
        prefix=""
    i=1
    total=len(inputfiles)
    for infile in inputfiles:
        progressBar(i,total,"RENAME")
        ext=pathlib.Path(infile).suffix
        new_file_name="{}_{:05d}{}".format(prefix,i,ext)
        os.rename(infile,new_file_name)
        i=i+1
    print()
# ---- RUNNING -----
if __name__=="__main__":
    parser=argparse.ArgumentParser('')
    parser.add_argument('-e',type=str,default=None,help='file extension')
    parser.add_argument('-dt',action='store_true',help='add date time')
    args=parser.parse_args()
    if args.e is None:
        print("pyrename --help")
        exit(0)
    files=list_files(args.e)
    rename_files(files,args.dt)
# ---- END OF PROGRAM ----
