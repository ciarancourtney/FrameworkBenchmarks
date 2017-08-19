#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "hello.settings")

    from django.core.management import execute_from_command_line

    agrv = sys.argv + ['runserver', '0.0.0.0:8080', '--no-color', '--nothreading', '--noreload', '--nostatic']
    execute_from_command_line(agrv)