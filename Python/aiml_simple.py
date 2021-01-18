#test aiml simplest
import aiml
import os

def main():
    kernel=aiml.Kernel()
    if os.path.isfile("bot_brain.brn"):
        kernel.bootstrap(brainFile="bot_brain.brn")
    else:
        kernel.bootstrap(learnFiles='std-startup.xml',commands='load aiml b')
        kernel.saveBrain('bot_brain.brn')
    while True:
        inMsg=input(">>")
        outMsg=kernel.respond(inMsg)
        print(outMsg)
if __name__=="__main__":
    main()