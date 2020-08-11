package hl.ws;

import hl.ws.IHander;
import hl.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import sys.net.Host;
import hl.uv.*;
import haxe.Constraints;
import hl.ws.ISession;

@:generic
class WebsocketServer  <T:Constructible<IHander->Void>> {
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

	
		tcp.listen(5, function() {
			var s = tcp.accept();
			var x = new WebSocketHandler(s);
			x.start();
			var session:ISession=cast new T(x);//here is parse and encode and decode byts.

			x.setupSession(session);
			

			
		});
	}

	public function close() {
		tcp.close(function() {
			trace('onclose');
		});
	}
}
