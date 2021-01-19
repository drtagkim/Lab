#test aiml simplest
import aiml
import os

def main():
    kernel=aiml.Kernel()
    kernel.bootstrap(learnFiles='std-startup-my.xml',commands='load hotel aiml')
    while True:
        inMsg=input(">>")
        outMsg=kernel.respond(inMsg)
        print(outMsg)
if __name__=="__main__":
    main()