import hl.ws.MessageType.MessageBuffType;
import haxe.io.Bytes;
import hl.ws.IHander;
import hl.ws.ISession;
import haxe.MainLoop;
import hl.ws.WebsocketServer;
import hl.ws.WebSocketClient;

class Session implements ISession{
	

	public function new(hander:IHander) {
		
		trace('new session');
	}

	public function addEvent(hander:IHander):Void{
		trace('addEvent'+hander.id);
	}
    public function onClose(hander:IHander):Void{
		trace('onClose'+hander.id);
	}
	public  function onOpen(hander:IHander):Void {
		trace(' onOpen'+hander.id);
	}
	public function addBytes(bytes:Bytes):Void{
		trace('addBytes');
	}



	public function onDataCS(hander:IHander) {

		trace("ondata"+hander.message);

       var ms:MessageBuffType=hander.message;
		hander.send(ms.text);
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
		var wsServer = new WebsocketServer<Session>('127.0.0.1', 5000);

		wsServer.start();

		// trace('here?');

		var wsClient = new WebSocketClient('ws://127.0.0.1:5000');

		wsClient.onopen = function() {
			trace('onopen---');

			wsClient.send('hello');
		}

		wsClient.onerror = function(e) {
			trace('error' + e);
		}

		wsClient.onmessage = function(e) {
			trace('onmessage' + e);

			if (e != null) {
				wsClient.close();
			}
		}

		wsClient.onclose = function() {
			trace('socket was close');
		}
	}
}
