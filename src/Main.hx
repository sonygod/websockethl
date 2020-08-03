
import haxe.MainLoop;
import hl.ws.WebsocketServer;
import hl.ws.WebSocketClient;

class Main {
	static function main() {
		var wsServer = new WebsocketServer('127.0.0.1', 5000);

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

			if(e!=null){
				wsClient.close();
			}
		}

		wsClient.onclose = function() {
			trace('socket was close');
		}
	}
}
