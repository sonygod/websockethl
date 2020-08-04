package hl.ws;

// import sys.thread.Mutex;
import hl.uv.Tcp;
import haxe.crypto.Base64;
import haxe.MainLoop;

class WebSocketClient extends WebSocketParse {
	public var _host:String;
	public var _port:Int;
	public var _uri:String;

	private var _key:String = "wskey";
	private var _encodedKey:String = "wskey";

	public var binaryType:BinaryType;

	public function new(uri:String) {
		var tcp = new Tcp(null);

		var uriRegExp = ~/^(\w+?):\/\/([\w\.-]+)(:(\d+))?(\/.*)?$/;

		if (!uriRegExp.match(uri)) {
			trace("error:url error");
			throw 'Uri not matching websocket uri "${uri}"';
		}

		trace('warning socket 131');
		var proto = uriRegExp.matched(1);
		if (proto == "wss") {
			_port = 443;
		} else if (proto == "ws") {
			_port = 80;
		} else {
			throw 'Unknown protocol $proto';
		}
		trace('warning socket 147');
		_host = uriRegExp.matched(2);
		var parsedPort = Std.parseInt(uriRegExp.matched(4));
		if (parsedPort > 0) {
			_port = parsedPort;
		}
		_uri = uriRegExp.matched(5);
		if (_uri == null || _uri.length == 0) {
			_uri = "/";
		}

		tcp.connect(new sys.net.Host(_host), _port, function(b) {
			if (b) {
				trace('connect');

				// sendHandshake();

				start();
				sendHandshake();
			} else {
				if (onerror != null) {
					onerror('connect error');
				}
			}
		});

		super(tcp);
	}

	public function sendHandshake() {
		var httpRequest = new HttpRequest();
		httpRequest.method = "GET";
		httpRequest.uri = _uri;
		httpRequest.httpVersion = "HTTP/1.1";
		httpRequest.headers.set(HttpHeader.HOST, _host + ":" + _port);
		httpRequest.headers.set(HttpHeader.USER_AGENT, "hxWebSockets");
		httpRequest.headers.set(HttpHeader.SEC_WEBSOSCKET_VERSION, "13");
		httpRequest.headers.set(HttpHeader.UPGRADE, "websocket");
		httpRequest.headers.set(HttpHeader.CONNECTION, "Upgrade");
		httpRequest.headers.set(HttpHeader.PRAGMA, "no-cache");
		httpRequest.headers.set(HttpHeader.CACHE_CONTROL, "no-cache");
		trace(_host + ":" + _port);
		httpRequest.headers.set(HttpHeader.ORIGIN, _host + ":" + _port);
		_encodedKey = Base64.encode(Utf8Encoder.encode(_key));

		httpRequest.headers.set(HttpHeader.SEC_WEBSOCKET_KEY, _encodedKey);
		sendHttpRequest(httpRequest);
	}

	private override function handleData() {
		switch (state) {
			case State.Handshake:
				var httpResponse = recvHttpResponse();
				if (httpResponse == null) {
					return;
				}
				handshake(httpResponse);
				handleData();
			case _:
				super.handleData();
		}
	}

	private function handshake(httpResponse:HttpResponse) {
		trace(httpResponse.toString());
		if (httpResponse.code != 101) {
			if (onerror != null) {
				onerror(httpResponse.headers.get(HttpHeader.X_WEBSOCKET_REJECT_REASON));
			}
			close();
			return;
		}
		var secKey = httpResponse.headers.get(HttpHeader.SEC_WEBSOSCKET_ACCEPT);
		if (secKey != makeWSKey(_encodedKey)) {
			if (onerror != null) {
				onerror("Error during WebSocket handshake: Incorrect 'Sec-WebSocket-Accept' header value");
			}
			close();
			return;
		}
		if (onopen != null) {
			onopen();
			onopen = null;
		}

		state = State.Head;
	}
}
