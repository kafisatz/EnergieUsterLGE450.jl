using Revise
using StatsBase;using DataFrames; using Pkg;
using EnergieUsterLGE450

sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_20221108_2115.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_20221108_2215.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_stopbits2.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_02xpythonformatter.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_evenlonger.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_incremental.txt"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","baud2400_longer.txt"))
@show sfi
@assert isfile(sfi)

dta = readlines(sfi)[1];
@show length(dta)
#sz = div(length(dta),2)
#bytes = map(i->dta[(i*2)+1:(i*2)+2],0:sz-1)
bytes = hex2bytes(dta)

start_marker = hex2bytes("7ea0")
mk = findall(bytes2hex(start_marker),dta)
length(mk)

sevenEs = findall(isequal(hex2bytes("7e")[1]),bytes);
i = sevenEs[2];
rs = map(i->bytes[i:i+1],sevenEs);
di = countmap(rs);
df = DataFrame(keys=collect(keys(di)),freq=collect(values(di)));
sort!(df,:freq,rev=true)
marker_candidate = df[1,:keys]

recurring_marker = "be1bd871"
addresses = ["6d34d871","8d30d871"] #???

"7e03"
marker_candidate = [0x7e,0x03]
mk = findall(bytes2hex(marker_candidate),dta)
@assert length(unique(length.(mk)))==1
mk03 = map(x->x[1],mk)

"7e01"
marker_candidate = [0x7e,0x01]
mk = findall(bytes2hex(marker_candidate),dta)
@assert length(unique(length.(mk)))==1
mk01 = map(x->x[1],mk)


"7e81" #???
marker_candidate = [0x7e,0x81]
mk = findall(bytes2hex(marker_candidate),dta)
@assert length(unique(length.(mk)))==1
mk81 = map(x->x[1],mk)

markers = sort(vcat(mk01,mk03))

i=4
frames = String[]
for i=1:length(markers)-1
    f = dta[markers[i]:markers[i+1]+3]
    push!(frames,f)
end

resfi = raw"c:\temp\frames2.txt"
isfile(resfi)&&rm(resfi)
fio = open(resfi,"w")
for f in frames
    write(fio,f)
    write(fio,"\r\n")
end
close(fio)

########################################################################
#fix data
########################################################################
oddlenidx = map(f->isodd(length(f)),frames)
findall(oddlenidx)
oddframes = frames[oddlenidx]
@assert length(oddframes) ==2
@assert findall(oddlenidx)[1] == findall(oddlenidx)[2]-1

#fix data
frames[findall(oddlenidx)[1]] = string(frames[findall(oddlenidx)[1]],frames[findall(oddlenidx)[2]])
deleteat!(frames,findall(oddlenidx)[2])
oddlenidx2 = map(f->isodd(length(f)),frames)
@assert sum(oddlenidx2) == 0
#end of fixing data 
########################################################################

dfframes = DataFrame(frame=frames)
dfframes.bytevec = map(f->hex2bytes(f),frames)
dfframes[!,:byte2] = map(bv->bytes2hex(bv[2]),dfframes.bytevec)
dfframes[!,:byte3] = map(bv->bytes2hex(bv[3]),dfframes.bytevec)
dfframes[!,:byte4] = map(bv->bytes2hex(bv[4]),dfframes.bytevec)

dfframes[!,:byte5and6] = map(bv->bytes2hex(bv[5:6]),dfframes.bytevec)
dfframes[!,:byte7] = map(bv->bytes2hex(bv[7]),dfframes.bytevec)
dfframes[!,:byte8] = map(bv->bytes2hex(bv[8]),dfframes.bytevec)
dfframes[!,:byte9] = map(bv->bytes2hex(bv[9]),dfframes.bytevec)
dfframes[!,:byte10] = map(bv->bytes2hex(bv[10]),dfframes.bytevec)

dfframes
dfframes.byte5and6

countmap(dfframes.byte8)
countmap(dfframes.byte9)
countmap(dfframes.byte10)

cml = countmap(length.(frames))
dflen = DataFrame(len=collect(keys(cml)),freq=collect(values(cml)))
sort!(dflen,:freq,rev=true)



bytes2hex(dfframes.byte3[1])

be1b
dfframes[!,:endswith_7eff7e03] = map(x->endswith(x,"7eff7e03"),dfframes.frame)
sum(dfframes[!,:endswith_7eff7e03])
dfframes.frame[2]




rr = readlines(raw"c:\temp\resultfile_20221108-223702.txt");
