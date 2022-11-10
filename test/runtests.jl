using EnergieUsterLGE450
using Test

@testset "EnergieUsterLGE450.jl" begin

    b1,b2,rs = crc16(UInt8[0xa0,0x8b,0xce,0xff,0x03,0x13])
    @test b1 == 0xe1
    @test b2 == 0xee

end
