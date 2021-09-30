import socket
from threading import Thread
from socket import socket as Socket

# function for bad http request
def get_bad_response():
        response = "HTTP/1.0 400 Bad Request\n"
        response += "Content-Type: text/html; encoding=utf-8\n"
        response += "Content-Length: %d\n" % len( "<html><body><h1>400: Bad Request </h1></body></html>")
        response += "Connection: close\n"
        response += "\n"
        response += "<html><body><h1>400: Bad Request </h1></body></html>"
        return response

# handle http client request
def http_handle(connection):
    request_string = connection.recv(1024).decode('utf-8')
    request_data = {}
    response = b''
    # try:
    request_split = request_string.split("\r\n")
    request_data["request_type"] = request_split[0]
    print(request_data)
    for index in range(1, len(request_split)):
        if (request_split[index] == ""):
            continue
        request_data[request_split[index].split(": ")[0]] = request_split[index].split(": ")[1]
    # parse request host
    host = request_data['request_type'].split('/')[1].split(' ')[0]
    # except Exception as e:
    #     print('error1', e.)
        # handle bad request
        # response = get_bad_response()
        # connection.send(response.encode("utf-8"))
        # connection.close()
        # return
    try:
        # establish socket to web site
        web_sock = Socket(socket.AF_INET, socket.SOCK_STREAM)
        web_sock.settimeout(0.1)
        web_sock.connect((host.replace("http://", "").replace("https://", ""), 80))
        # proxy send request to web site
        web_sock.sendall(str.encode("GET /index.html HTTP/1.0\r\nHost: %s\r\n\r\n" % host.replace("http://", "").replace("https://", "")))
        # read reponse
        while True:
            try:
                data = web_sock.recv(4096)
                if len(data) == 0:
                    break
                response += data
            except:
                break

        web_sock.close()
        response = response.decode('utf-8')
        # print for log
        print('get..............')
        print(response)
        # send response back to client
        ret = connection.sendall(response.encode("utf-8"))
        print(f'ret {ret}')
        connection.close()
    except Exception as e:
        print('error 2', e)
        response = get_bad_response()
        connection.send(response.encode("utf-8"))
        connection.close()

def main():
    with Socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        # setup proxy server
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(('localhost', 8888))
        sock.listen()
        print("proxy running...")
        while True:
            # loop for read request
            client, _ = sock.accept()
            thread = Thread(target = http_handle, args = (client,) )
            thread.start()



if __name__ == "__main__":
    main()