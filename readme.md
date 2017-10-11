Just following some guides on socket programming:

* https://www.destroyallsoftware.com/screencasts/catalog/http-server-from-scratch
* http://beej.us/guide/bgnet/

## Usage

Read file:

```
killall ruby; ./server.rb&; sleep 0.1; curl -v http://127.0.0.1:9000/readme.md
```
