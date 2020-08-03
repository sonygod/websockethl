package hl.ws;

import haxe.io.Bytes;

class WebSocketHandler extends WebSocketParse {
	public function new(socket) {
		super(socket);
	}

	private override function handleData() {
		switch (state) {
			case State.Handshake:
				var httpRequest = recvHttpRequest();
				if (httpRequest == null) {
					trace('warning  no http requrest!');
					return;
				}

				handshake(httpRequest);

				handleData();
			case _:
				super.handleData();
		}
	}

	public function handshake(httpRequest:HttpRequest) {
		var httpResponse = new HttpResponse();

		httpResponse.headers.set(HttpHeader.SEC_WEBSOSCKET_VERSION, "13");

		if (httpRequest.headers.exists("REMOTE-HOST")) {
			remoteIP = httpRequest.headers.get("REMOTE-HOST");
			trace('remoteIp' + remoteIP);
		}
		if (httpRequest.headers.exists("Origin")) {
			origin = httpRequest.headers.get("Origin");
			trace('from origin=' + origin);
		}
		if (httpRequest.method != "GET" || httpRequest.httpVersion != "HTTP/1.1") {
			httpResponse.code = 400;
			httpResponse.text = "Bad";
			httpResponse.headers.set(HttpHeader.CONNECTION, "close");
			httpResponse.headers.set(HttpHeader.X_WEBSOCKET_REJECT_REASON, 'Bad request');
		} else if (httpRequest.headers.get(HttpHeader.SEC_WEBSOSCKET_VERSION) != "13") {
			httpResponse.code = 426;
			httpResponse.text = "Upgrade";
			httpResponse.headers.set(HttpHeader.CONNECTION, "close");
			httpResponse.headers.set(HttpHeader.X_WEBSOCKET_REJECT_REASON,
				'Unsupported websocket client version: ${httpRequest.headers.get(HttpHeader.SEC_WEBSOSCKET_VERSION)}, Only version 13 is supported.');
		} else if (httpRequest.headers.get(HttpHeader.UPGRADE) != "websocket") {
			httpResponse.code = 426;
			httpResponse.text = "Upgrade";
			httpResponse.headers.set(HttpHeader.CONNECTION, "close");
			httpResponse.headers.set(HttpHeader.X_WEBSOCKET_REJECT_REASON, 'Unsupported upgrade header: ${httpRequest.headers.get(HttpHeader.UPGRADE)}.');
			// } else if (httpRequest.headers.get(HttpHeader.CONNECTION) != "Upgrade") {
		} else if (httpRequest.headers.get(HttpHeader.CONNECTION).indexOf("Upgrade") == -1) {
			httpResponse.code = 426;
			httpResponse.text = "Upgrade";
			httpResponse.headers.set(HttpHeader.CONNECTION, "close");
			httpResponse.headers.set(HttpHeader.X_WEBSOCKET_REJECT_REASON,
				'Unsupported connection header: ${httpRequest.headers.get(HttpHeader.CONNECTION)}.');
		} else {
			var key = httpRequest.headers.get(HttpHeader.SEC_WEBSOCKET_KEY);
			var result = makeWSKey(key);

			// for(key=>v in httpRequest.headers){
			//     trace('key=$key v=$v');
			// }

			httpResponse.code = 101;
			httpResponse.text = "Switching Protocols";
			httpResponse.headers.set(HttpHeader.UPGRADE, "websocket");
			httpResponse.headers.set(HttpHeader.CONNECTION, "Upgrade");
			httpResponse.headers.set(HttpHeader.SEC_WEBSOSCKET_ACCEPT, result);
		}

		sendHttpResponse(httpResponse);

		if (httpResponse.code == 101) {
			_onopenCalled = false;
			state = State.Head;

			// Log.debug('Connected', id);
		} else {
			close();
		}
	}
}
