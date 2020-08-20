package hc.ws;

import hxuv.Tcp;
import hc.ws.IHander;
import hc.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import sys.net.Host;
import haxe.Constraints;
import hc.ws.ISession;

@:generic
class WebsocketServer<T:Constructible<IHander->Void>> {
	var tcp:Tcp;
	var host:Host;
	var port:Int;

	public function new(url:String, port:Int) {
		tcp = Tcp.alloc();
		host = new sys.net.Host(url);
		tcp.bind(url, port, 0);
		this.port = port;
	}

	public function start() {
		tcp.bind(host.host, port, 0);

		tcp.listen(128, function(_) {
			var client = Tcp.alloc();
			tcp.accept(client);
			var x = new WebSocketHandler(client);
			x.start();
			var session:ISession = cast new T(x); // here is parse and encode and decode byts.

			x.setupSession(session);
		});
	}

	public function close() {
		tcp.close(function() {
			trace('onclose');
		});
	}
}
