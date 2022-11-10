#using Test 
#using CRC 
#= 
see also https://crccalc.com/
crc16/x-25 is used by hdlc
https://reveng.sourceforge.io/crc-catalogue/16.htm#crc.cat-bits.16
CRC-16/IBM-SDLC
width=16 poly=0x1021 init=0xffff refin=true refout=true xorout=0xffff check=0x906e residue=0xf0b8 name="CRC-16/IBM-SDLC"

Class: attested
Alias: CRC-16/ISO-HDLC, CRC-16/ISO-IEC-14443-3-B, CRC-16/X-25, CRC-B, X-25
HDLC is defined in ISO/IEC 13239. CRC_B is defined in ISO/IEC 14443-3.
=#

#A0	8B	CE	FF	03	13
#0xE1EE

#@show sort(string.(collect(keys(CRC.ALL))))

crcfn = CRC.crc(CRC.CRC_16_X_25)
#crcfn("A08BCEFF0313")

#rs = crcfn(UInt8[0xa0,0x8b,0xce,0xff,0x03,0x13])
#crcfn(UInt8[0xa0,0x8b,0xce,0xff,0x03,0x13])
export crc16 
function crc16(v::Vector{UInt8};fn = crcfn)
    #rs = crcfn(UInt8[0xa0,0x8b,0xce,0xff,0x03,0x13])
    rs = crcfn(v)
    byte1 = (rs>>>8)%UInt8
    byte2 = rs%UInt8
    return byte1,byte2,rs
end

