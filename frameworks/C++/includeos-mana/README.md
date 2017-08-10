# Mana Benchmarking Test

[Mana](https://github.com/includeos/mana) is a web framework for modern C++, designed to be run on the IncludeOS unikernel.

### Features

* Serve static content from a disk with just a few lines of code.
* RESTful API service reading and posting JSON.
* Real-time information about the server with an interactive Dashboard

Acorn is a simple web server using a collection of libraries and extensions:

* [Mana](../../lib/mana) - IncludeOS Web Appliance Framework
* [Bucket](https://github.com/includeos/bucket) - Simplified in-memory database

Content to be served can be found (and edited) in the directory [disk1](disk1/).

### Test URLs

[/plaintext](http://www.techempower.com/benchmarks/#section=plaintext)
----------
```
HTTP/1.1 200 OK
Server: IncludeOS/v0.11.0
Content-Type: text/plain
Date: Mon, 01 Jan 1970 00:00:01 GMT
Content-Length: 13

Hello, world!
```
