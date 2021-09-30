Only the python standard library is used

1.Command to run web server:
python webserver.py
open chrome and enter "http://127.0.0.1:6789/HelloWorld.html"
if you want to access from another host, you can uncomment "self.socket.bind((localip, 6789))"(line 24) and comment "self.socket.bind(('127.0.0.1',6789))"(line 25)

2.Command to run proxy server
python proxyserver.py
open chrome and enter "http://localhost:8888/google.com"