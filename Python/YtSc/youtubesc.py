#YouTube Image Download CLI
#Taekyung Kim, Kwangwoon University
#2021-01-22
#version 0.0.1

from types import MethodType
from pytube import request
from pytube.cli import on_progress
import cv2
import pytube
import glob
import os
import os.path
import argparse #CLI
import time
#res_top=highest quality
def download_youtube(vid,folder_name='',res_top=1):
    video_url="https://www.youtube.com/watch?v=%s"%(vid,)
    yv=pytube.YouTube(video_url,on_progress_callback=on_progress)
    #yv.register_on_progress_callback(progress_func)
    video=yv.streams
    mp4files=[v for v in video if v.mime_type=="video/mp4"]
    if res_top:
        v=mp4files[0]
    else:
        v=mp4files[-1]
    v.download(folder_name,"youtube")
def capture_sc(input_folder,output_folder,sec=60,max_pic=500):
    video_file=glob.glob("./%s/*.mp4"%(input_folder,))[0]
    vidcap=cv2.VideoCapture(video_file)
    #top=measure_length(vidcap)
    success,image=vidcap.read()
    count=0
    cv2.imwrite('./%s/img_%05d.jpg'%(output_folder,count),image)
    count+=1
    while success:
        step=count*1000*sec #every 1 min
        vidcap.set(cv2.CAP_PROP_POS_MSEC,step)
        cv2.imwrite('./%s/img_%05d.jpg'%(output_folder,count),image)
        success,image=vidcap.read()
        count+=1
        if count > max_pic:
            break
def main():
    parser=argparse.ArgumentParser('YouTube Movie Screenshot - Taekyung Kim, Kwangwoon University, 2021')
    parser.add_argument('--vid',required=True,help='')
    parser.add_argument('--movfolder',required=True,help='')
    parser.add_argument('--picfolder',required=True,help='')
    parser.add_argument('--res',default='1',help='resolution, 1=highest 0=lowest')
    parser.add_argument('--sec',default='60',help='seconds')
    parser.add_argument('--maxpic',default='500',help='maximum pics')
    args=parser.parse_args()
    vid=args.vid #"ra0Laa0nobU" #unboxing
    mov_folder=args.movfolder #"mov"
    pic_folder=args.picfolder #"pic"
    #
    if not os.path.exists(mov_folder):
        os.mkdir(mov_folder)
        print("---> Movie folder creation OK.")
    if not os.path.exists(pic_folder):
        os.mkdir(pic_folder)
        print("---> Picture folder creation OK.")
    res_top=int(args.res)
    sec=int(args.sec)
    maxpic=int(args.maxpic)
    download_youtube(vid,mov_folder,res_top=res_top)
    print("---> Donwload OK.")
    capture_sc(mov_folder,pic_folder,sec,maxpic)
    print("---> Pictures OK")
if __name__=="__main__":
    main()
