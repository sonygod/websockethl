package hl.ws;

interface IHander 
{
	 public var id:Int;
	 
	 public var message:Dynamic;
	 public var error:Dynamic;
	 public function close():Void;
	 public function send(data:Any):Void;
	 
}