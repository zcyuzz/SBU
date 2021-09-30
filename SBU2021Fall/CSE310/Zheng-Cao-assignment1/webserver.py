import mimetypes
import os
import socket

# represent HTTP request
class HTTPRequest:

    def __init__(self, data):
        # contains http method path version request infos
        lines = [line.strip() for line in data.decode().split("\n") if line.strip()]
        self.method, self.path, self.version = lines[0].split(' ')
        self.kvs = {k: v for k, v in (l.split(': ') for l in lines[1:])}

# Server class handle socket send and recv
class Server:
    def __init__(self):
        self.socket = None

    # open socket
    def open(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # get ip address
        localip =socket.gethostbyname(socket.gethostname())
        #self.socket.bind((localip, 6789))
        self.socket.bind(('127.0.0.1',6789))

    # close server socket
    def close(self):
        if self.socket:
            self.socket.close()

    def listen(self):
        self.socket.listen()
        # store client socket
        self.conn, _ = self.socket.accept()
        # read request data
        data = self.conn.recv(4096)
        return HTTPRequest(data)

    def respond(self, data):
        # reply request to client
        self.conn.send(data)
        self.conn.close()

# main class of web server
class WebServer:
    def __init__(self):
        self.server = Server()
        # working dictionary
        self.dir = os.path.curdir

    def serve(self):
        self.server.open()
        # loop for handle http request
        while True:
            self.handle_request()

    def stop(self):
        self.server.close()

    def handle_request(self):
        request = self.server.listen()
        path = request.path
        try:
            with open(os.path.join(self.dir, path.lstrip('/'))) as f:
                body, status = f.read(), 200
        except FileNotFoundError:
            body, status = '404 Not Found', 404
        # parse http header
        header = self.get_header(status, path)
        # reply http request
        self.server.respond((header + body).encode())

    def get_header(self, status, path):
        STATUSES = {
            200: 'Ok',
            404: 'File not found',
        }
        _, file_ext = os.path.splitext(path)
        # construct header
        return "\n".join([
            "HTTP/1.1 {} {}".format(status, STATUSES[status]),
            "Content-Type: {}".format(mimetypes.types_map.get(file_ext, 'application/octet-stream')),
            "Server: SimplePython Server"
            "\n\n"
        ])

if __name__ == "__main__":
    server = WebServer()
    try:
        server.serve()
    finally:
        server.stop()