
import uv.Uv;
import uv.Loop;
import uv.Tcp;
import haxe.io.BytesInput;
import sys.FileSystem;
import sys.io.File;
import hc.ws.MessageType.MsgTYpe;
import haxe.Timer;
import hc.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import hc.ws.IHander;
import hc.ws.ISession;
import haxe.MainLoop;
import hc.ws.WebsocketServer;
import hc.ws.WebSocketClient;



class Session implements ISession {
	public function new(hander:IHander) {
		trace('new session');
	}

	public function addEvent(hander:IHander):Void {
		trace('addEvent' + hander.id);
	}

	public function onClose(hander:IHander):Void {
		trace('onClose' + hander.id);
	}

	public function onOpen(hander:IHander):Void {
		trace(' onOpen' + hander.id);

		if (FileSystem.exists('./fishlist6012.data')) {
			var f = File.read("./fishlist6012.data", true);
			var b = f.readAll();
			hander.send(b);
		} else {
			trace('file not exit');
		}
	}

	public function addBytes(bytes:Bytes):Void {
		trace('addBytes');
	}

	public function onDataCS(hander:IHander) {
		trace("ondata" + hander.message);

		var ms:MessageBuffType = hander.message;

		if (ms.type == MsgTYpe.text) {
			hander.send(ms.text);
		} else {
			hander.send(ms.data);
		}

		// x.onmessage=function (ms:MessageBuffType) {

		// 	if(ms.type==text){
		// 		trace(ms.text);
		// 		x.send(ms.text);
		// 	}
		// }
	}
}

class Main {
	static function main() {
		var wsServer = new WebsocketServer<Session>('127.0.0.1', 9000);

		wsServer.start();

		trace('ws start');

		var wsClient = new WebSocketClient('ws://127.0.0.1:9000');

		wsClient.onopen = function() {
			trace('onopen---');

			wsClient.send('hello');
		}

		wsClient.onerror = function(e) {
			trace('error' + e);
		}

		wsClient.onmessage = function(e) {
			trace('onmessage' + e);

			if (e.type == MsgTYpe.binary) {
				var bytes:Bytes = cast e.data.readAllAvailableBytes();
				var bi = new BytesInput(bytes);
				var z = bi.readByte();
				var h = bi.readByte();
				var y = bi.readByte();
				var v1 = bi.readByte();
				var v2 = bi.readByte();
				var v3 = bi.readByte();

				trace(z, h, y, v1, v2, v3);
			}
			if (e != null) {
				wsClient.close();
			}
		}

		wsClient.onclose = function() {
			trace('socket was close');
		}
		Loop.DEFAULT.run(Uv.RUN_DEFAULT);
	}
}
