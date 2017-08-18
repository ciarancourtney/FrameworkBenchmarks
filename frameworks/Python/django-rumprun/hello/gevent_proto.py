from gevent.wsgi import WSGIServer
from hello.wsgi import application

http_server = WSGIServer(('0.0.0.0', 8080), application)
http_server.serve_forever()
