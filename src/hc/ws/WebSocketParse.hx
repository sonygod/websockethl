package hc.ws;

import cpp.Callable;
import uv.Tcp;
import hc.ws.HttpResponse;
import haxe.io.Bytes;
import haxe.io.Error;
import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import hc.ws.MessageType.MsgTYpe;
import hc.ws.MessageType.MessageBuffType;
import haxe.io.UInt8Array;
import cpp.*;
import uv.*;
import uv.Uv;
import haxe.io.Bytes;
import hxuv.Tcp;



class WebSocketParse implements IHander {
	private static var _nextId:Int = 1;

	public var id:Int;
	public var state:State = State.Handshake;

	private var _socket:Tcp;

	private var _onopenCalled:Null<Bool> = null;
	private var _lastError:Dynamic = null;

	public var onopen:Void->Void;
	public var onclose:Void->Void;
	public var onerror:Dynamic->Void;
	public var onmessage:MessageBuffType->Void;

	public var remoteIP:String = "0.0.0.0";
	public var origin:String = 'localhost';

	private var _buffer:Buffer = new Buffer();

	public var message:Dynamic;
	public var error:Dynamic;

	public function new(socket:Tcp) {
		id = _nextId++;

		_socket = socket;
	}

	public function start() {
		_socket.readStart(function(status, bytes) {
			if (bytes != null){
				onRead(bytes);
			}else{
              close();
			}
				
		});
	}

	public function onRead(b:Bytes) {
		process();
		if (b != null) {
			_buffer.writeBytes(b);
			var x = b.toString();
		} else {
			return;
		}

		handleData();
	}

	public function send(data:Any) {
		if (Std.is(data, String)) {
			sendFrame(Utf8Encoder.encode(data), OpCode.Text);
		} else if (Std.is(data, Bytes)) {
			sendFrame(data, OpCode.Binary);
		} else if (Std.is(data, Buffer)) {
			sendFrame(cast(data, Buffer).readAllAvailableBytes(), OpCode.Binary);
		}
	}

	private function sendFrame(data:Bytes, type:OpCode) {
		writeBytes(prepareFrame(data, type, true));
	}

	private var _isFinal:Bool;
	private var _isMasked:Bool;
	private var _opcode:OpCode;
	private var _frameIsBinary:Bool;
	private var _partialLength:Int;
	private var _length:Int;
	private var _mask:Bytes;
	private var _payload:Buffer = null;
	private var _lastPong:Date = null;

	private function handleData() {
		switch (state) {
			case State.Head:
				if (_buffer.available < 2)
					return;

				var b0 = _buffer.readByte();
				var b1 = _buffer.readByte();

				_isFinal = ((b0 >> 7) & 1) != 0;
				_opcode = cast(((b0 >> 0) & 0xF), OpCode);
				_frameIsBinary = if (_opcode == OpCode.Text) false; else if (_opcode == OpCode.Binary) true; else _frameIsBinary;
				_partialLength = ((b1 >> 0) & 0x7F);
				_isMasked = ((b1 >> 7) & 1) != 0;

				state = State.HeadExtraLength;
				handleData(); // may be more data
			case State.HeadExtraLength:
				if (_partialLength == 126) {
					if (_buffer.available < 2)
						return;
					_length = _buffer.readUnsignedShort();
				} else if (_partialLength == 127) {
					if (_buffer.available < 8)
						return;
					var tmp = _buffer.readUnsignedInt();
					if (tmp != 0)
						throw 'message too long';
					_length = _buffer.readUnsignedInt();
				} else {
					_length = _partialLength;
				}
				state = State.HeadExtraMask;
				handleData(); // may be more data
			case State.HeadExtraMask:
				if (_isMasked) {
					if (_buffer.available < 4)
						return;
					_mask = _buffer.readBytes(4);
				}
				state = State.Body;
				handleData(); // may be more data
			case State.Body:
				if (_buffer.available < _length)
					return;
				if (_payload == null) {
					_payload = new Buffer();
				}
				_payload.writeBytes(_buffer.readBytes(_length));

				switch (_opcode) {
					case OpCode.Binary | OpCode.Text | OpCode.Continuation:
						if (_isFinal) {
							var messageData = _payload.readAllAvailableBytes();
							var unmaskedMessageData = (_isMasked) ? applyMask(messageData, _mask) : messageData;
							if (_frameIsBinary) {
								if (this.onmessage != null) {
									var buffer = new Buffer();
									buffer.writeBytes(unmaskedMessageData);

									this.onmessage({
										type: MsgTYpe.binary,
										data: buffer
									});
								}
							} else {
								var stringPayload = Utf8Encoder.decode(unmaskedMessageData);

								if (this.onmessage != null) {
									this.onmessage({
										type: MsgTYpe.text,
										text: stringPayload
									});
								}
							}
							_payload = null;
						}
					case OpCode.Ping:
						sendFrame(_payload.readAllAvailableBytes(), OpCode.Pong);
					case OpCode.Pong:
						_lastPong = Date.now();
					case OpCode.Close:
						close();
				}

				if (state != State.Closed)
					state = State.Head;
				handleData(); // may be more data
			case State.Closed:
				close();
			case _:
				trace('State not impl: ${state}');
		}
	}

	public function close():Void {
		if (state != State.Closed) {
			try {
				trace(" close socket!!!!");
				sendFrame(Bytes.alloc(0), OpCode.Close);
				state = State.Closed;

				_socket.close(function() {
					trace('socket close');
				});
				// throw "主动关闭？";
			} catch (e:Dynamic) {}

			if (onclose != null) {
				onclose();
				onclose = null;
				onopen = null;
				onmessage = null;
				onerror = null;
				_socket = null;
			}
		} else {
			trace('warning socket was closed.');
		}
	}

	private function writeBytes(data:Bytes) {
		try {
			_socket.write(data, function(_) {});
		} catch (e:Dynamic) {
			// Log.debug(e, id);
			// trace(Std.string(e));
			if (onerror != null) {
				onerror(Std.string(e));
			}
		}
	}

	private function prepareFrame(data:Bytes, type:OpCode, isFinal:Bool):Bytes {
		var out = new Buffer();
		var isMasked = false; // All clientes messages must be masked: http://tools.ietf.org/html/rfc6455#section-5.1
		var mask = generateMask();
		var sizeMask = (isMasked ? 0x80 : 0x00);

		out.writeByte(type.toInt() | (isFinal ? 0x80 : 0x00));

		if (data.length < 126) {
			out.writeByte(data.length | sizeMask);
		} else if (data.length < 65536) {
			out.writeByte(126 | sizeMask);
			out.writeShort(data.length);
		} else {
			out.writeByte(127 | sizeMask);
			out.writeInt(0);
			out.writeInt(data.length);
		}

		if (isMasked)
			out.writeBytes(mask);

		out.writeBytes(isMasked ? applyMask(data, mask) : data);
		return out.readAllAvailableBytes();
	}

	private static function generateMask() {
		var maskData = Bytes.alloc(4);
		maskData.set(0, Std.random(256));
		maskData.set(1, Std.random(256));
		maskData.set(2, Std.random(256));
		maskData.set(3, Std.random(256));
		return maskData;
	}

	private static function applyMask(payload:Bytes, mask:Bytes) {
		var maskedPayload = Bytes.alloc(payload.length);
		for (n in 0...payload.length)
			maskedPayload.set(n, payload.get(n) ^ mask.get(n % mask.length));
		return maskedPayload;
	}

	private var lastTimeList:Array<Float> = [];

	private var index:Int = 0;

	private function process() {
		if (_onopenCalled == false) {
			_onopenCalled = true;
			if (onopen != null) {
				onopen();
			}
		}

		if (_lastError != null) {
			var error = _lastError;
			_lastError = null;
			if (onerror != null) {
				onerror(error);
			}
		}
	}

	public function sendHttpRequest(httpRequest:HttpRequest) {
		var data = httpRequest.build();
		var b = Bytes.ofString(data);

		var testb = new Buffer();

		testb.writeBytes(b);

		while (true) {
			var c = testb.readLine();

			if (c == null) {
				break;
			}
			trace(c);
		}
		trace(b.length);
		try {
			_socket.write(b, function(_) {});
		} catch (e:Dynamic) {
			if (onerror != null) {
				onerror(Std.string(e));
			}
			close();
		}
	}

	public function sendHttpResponse(httpResponse:HttpResponse) {
		var data = httpResponse.build();

		_socket.write(Bytes.ofString(data), function(_) {});
	}

	public function recvHttpRequest():HttpRequest {
		if (!_buffer.endsWith("\r\n\r\n")) {
			return null;
		}

		var httpRequest = new HttpRequest();
		while (true) {
			var line = _buffer.readLine();
			if (line == null) {
				break;
			}
			if (line == "") {
				continue;
			}
			httpRequest.addLine(line);
		}

		return httpRequest;
	}

	public function recvHttpResponse():HttpResponse {
		var response = _buffer.readLinesUntil("\r\n\r\n");

		if (response == null) {
			return null;
		}

		var httpResponse = new HttpResponse();
		for (line in response) {
			if (line == null || line == "") {
				break;
			}
			httpResponse.addLine(line);
		}

		return httpResponse;
	}

	private inline function makeWSKey(key:String):String {
		return Base64.encode(Sha1.make(Bytes.ofString(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')));
	}
}
