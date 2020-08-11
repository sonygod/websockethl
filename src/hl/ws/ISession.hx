package hl.ws;

interface ISession {
    
    function addEvent(hander:IHander):Void;
    function onClose(hander:IHander):Void;
    function onOpen(hander:IHander):Void ;
    function addBytes(bytes:haxe.io.Bytes):Void;
    function onDataCS(hander:IHander):Void;

}