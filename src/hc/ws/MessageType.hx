package hc.ws;

import hc.ws.Buffer;

typedef MessageBuffType = {
	@:optional var data:Buffer;
	var type:MsgTYpe;
	@:optional var text:String;
}

enum MsgTYpe {
	text;
	binary;
}
