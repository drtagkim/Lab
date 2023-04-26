from flask import Flask
import webview
import sys
import threading

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

def start_server():
    app.run(host='0.0.0.0', port=80)

if __name__ == '__main__':

    t = threading.Thread(target=start_server)
    t.daemon = True
    t.start()

    webview.create_window("PyWebView & Flask", "http://localhost/")
    webview.start()
    sys.exit()
