package hl.ws;

import hl.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import sys.net.Host;
import hl.uv.*;

class WebsocketServer {
	var tcp:Tcp;
	var host:Host;
	var port:Int;


	public function new(url:String, port:Int) {
		var loop = Loop.getDefault();
		tcp = new Tcp(loop);
		host = new sys.net.Host(url);
		this.port = port;
	}

	public function start() {
		tcp.bind(host, port);

		tcp.listen(1, function() {
			var s = tcp.accept();
			var x = new WebSocketHandler(s);
			x.onmessage=function (ms:MessageBuffType) {
				
				if(ms.type==text){
					trace(ms.text);
					x.send(ms.text);
				}
			}
		});
	}

	public function close() {
		tcp.close(function() {
			trace('onclose');
		});
	}
}
