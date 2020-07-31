package hl.ws;

enum State {
    Handshake;
    Head;
    HeadExtraLength;
    HeadExtraMask;
    Body;
    Closed;
}
