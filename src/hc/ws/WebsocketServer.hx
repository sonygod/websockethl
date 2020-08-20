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

using TcpHelper;

@:generic
class WebsocketServer<T:Constructible<IHander->Void>> {
	var tcp:Tcp;
	var host:Host;
	var port:Int;

	public function new(url:String, port:Int) {
		var loop = Loop.DEFAULT;

		var addr = new SockAddrIn();
		addr.ip4Addr(url, port);
		tcp = new Tcp();
		tcp.init(loop);
		tcp.bind(addr, 0);
		addr.destroy();
	}

	public function start() {
		tcp.asStream().listen(128, Callable.fromStaticFunction(onConnection));
	}

	function onConnection(stream:RawPointer<Stream_t>, status:Int) {
		trace('connected');
		var server:Tcp = stream;
		var client = new Tcp();
		client.init(Loop.DEFAULT);
		if (server.asStream().accept(client) == 0) {
			trace('accepted');
			trace(client.getPeerAddress());
			trace(client.getSockAddress());
			trace(client.asStream().readStop());
			var x = new WebSocketHandler(client);
			x.start();
			var session:ISession = cast new T(x); // here is parse and encode and decode byts.

			x.setupSession(session);
			// client.asStream().readStart(Callable.fromStaticFunction(onAlloc), Callable.fromStaticFunction(onRead));
		} else {
			client.asHandle().close(null);
		}
	}

	public function close() {
		tcp.close(function() {
			trace('onclose');
		});
	}
}
