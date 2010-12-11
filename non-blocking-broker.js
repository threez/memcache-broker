var http     = require('http');
var sys      = require('sys');
var url      = require('url');
var memcache = require('./lib/memcache');

mcClient = new memcache.Client();
mcClient.connect();

http.createServer(function (request, response) {
  var begin = new Date();
  response.writeHead(200, {'Content-Type': 'text/plain'});
  var pathname = url.parse(request.url).pathname;
  
	mcClient.get(pathname.substr(1, pathname.length), function(data) {
    response.end(data);
    var currentTime = new Date();
    var sec = (currentTime.getTime() - begin.getTime()) / 1000.0;
    console.log("" + request.connection.remoteAddress + " - - [" + 
                currentTime.toGMTString() + "] " + request.method + " " + pathname + 
                " " + request.httpVersion + " " + data.length + " " + sec + " s");
	});
}).listen(8124);

console.log('Server running at http://127.0.0.1:8124/');
