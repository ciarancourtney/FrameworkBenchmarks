import os.path

import cherrypy
from cherrypy.process import wspbus, plugins

# setting up django as standalone server
import os
os.environ["DJANGO_SETTINGS_MODULE"] = "hello.settings"
import django
django.setup()

from django.conf import settings
from django.core.handlers.wsgi import WSGIHandler


class Server(object):
    HOST = '0.0.0.0'
    PORT = 8080

    def __init__(self):
        self.base_dir = os.path.join(os.path.abspath(os.getcwd()), "hello")

        cherrypy.config.update({
            'server.socket_host': self.HOST,
            'server.socket_port': self.PORT,
            'server.thread_pool': 1,
            'engine.autoreload_on': False,
            'log.screen': True
        })

        cherrypy.engine.timeout_monitor.unsubscribe()

        # This registers a plugin to handle the Django app
        # with the CherryPy engine, meaning the app will
        # play nicely with the process bus that is the engine.
        DjangoAppPlugin(cherrypy.engine, self.base_dir).subscribe()

    def run(self):
        cherrypy.config.update({
            'server.socket_host': self.HOST,
            'server.socket_port': self.PORT,
            'engine.autoreload_on': False,
            'log.screen': True
        })
        engine = cherrypy.engine
        engine.signal_handler.subscribe()

        if hasattr(engine, "console_control_handler"):
            engine.console_control_handler.subscribe()

        print('eng start')
        engine.start()

        print('eng block')
        engine.block()


class DjangoAppPlugin(plugins.SimplePlugin):
    def __init__(self, bus, base_dir):
        """
        CherryPy engine plugin to configure and mount
        the Django application onto the CherryPy server.
        """
        plugins.SimplePlugin.__init__(self, bus)
        self.base_dir = base_dir

    def start(self):
        self.bus.log("Configuring the Django application")


        self.bus.log("Mounting the Django application")
        cherrypy.tree.graft(WSGIHandler())

        self.bus.log("Setting up the static directory to be served")
        # We server static files through CherryPy directly
        # bypassing entirely Django
        staticpath = os.path.abspath(self.base_dir)
        staticpath = os.path.split(staticpath)[0]
        staticpath = os.path.join(staticpath, 'static')

        static_handler = cherrypy.tools.staticdir.handler(section="/", dir=staticpath,
                                                          root='')
        cherrypy.tree.mount(static_handler, '/static')


if __name__ == '__main__':
    Server().run()