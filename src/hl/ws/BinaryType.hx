package hl.ws;



@:enum abstract BinaryType(String) {
    var ARRAYBUFFER = "arraybuffer";

    @:to public function toString() {
        return this;
    }
}

