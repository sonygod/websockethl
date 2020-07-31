import hl.ws.WebsocketServer;

class Main {
	static function main() {
		trace("Hello, world!");

		var ws=new WebsocketServer('0.0.0.0',50001);
		ws.start();
	}
}
