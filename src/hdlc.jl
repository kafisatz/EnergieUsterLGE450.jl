#https://www.tutorialspoint.com/high-level-data-link-control-hdlc#:~:text=HDLC%20is%20a%20bit%20%2D%20oriented,of%20the%20flag%20is%2001111110.

#=
    HDLC is a bit - oriented protocol where each frame contains up to six fields. The structure varies according to the type of frame. The fields of a HDLC frame are −

    Flag − It is an 8-bit sequence that marks the beginning and the end of the frame. The bit pattern of the flag is 01111110.

    Address − It contains the address of the receiver. If the frame is sent by the primary station, it contains the address(es) of the secondary station(s). If it is sent by the secondary station, it contains the address of the primary station. The address field may be from 1 byte to several bytes.

    Control − It is 1 or 2 bytes containing flow and error control information.

    Payload − This carries the data from the network layer. Its length may vary from one network to another.

    FCS − It is a 2 byte or 4 bytes frame check sequence for error detection. The standard code used is CRC (cyclic redundancy code)

##################

    Types of HDLC Frames
There are three types of HDLC frames. The type of frame is determined by the control field of the frame −

I-frame − I-frames or Information frames carry user data from the network layer. They also include flow and error control information that is piggybacked on user data. The first bit of control field of I-frame is 0.

S-frame − S-frames or Supervisory frames do not contain information field. They are used for flow and error control when piggybacking is not required. The first two bits of control field of S-frame is 10.

U-frame − U-frames or Un-numbered frames are used for myriad miscellaneous functions, like link management. It may contain an information field, if required. The first two bits of control field of U-frame is 11.

=#