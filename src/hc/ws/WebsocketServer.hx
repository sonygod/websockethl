package hc.ws;

import hc.ws.IHander;
import hc.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import sys.net.Host;
import haxe.Constraints;
import hc.ws.ISession;
import haxe.io.UInt8Array;
import cpp.*;
import uv.*;
import uv.Uv;
import haxe.io.Bytes;
import hxuv.Tcp;


@:generic
class WebsocketServer<T:Constructible<IHander->Void>> {
	var server:Tcp;
	var host:String;
	var port:Int;

	public function new(url:String, port:Int) {
		 server = Tcp.alloc();
		var status=server.bind(url, port, 0);
		trace('server bind status= $status');
	}

	public function start() {
		server.listen(128, function(_) {
			var client = Tcp.alloc();
			server.accept(client);


			var x = new WebSocketHandler(client);
			x.start();
			var session:ISession = cast new T(x); // here is parse and encode and decode byts.

			x.setupSession(session);
		});
		
	}

	

	public function close() {
		server.close(function() {
			trace('onclose');
		});
	}
}
