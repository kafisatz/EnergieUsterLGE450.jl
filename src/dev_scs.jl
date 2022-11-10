using Revise
using StatsBase;using DataFrames; using Pkg;using CSV
using EnergieUsterLGE450

#pi@pi4:~/nbsm $ journalctl -u python3-smartmeter-datacollector > my_sps_log.log
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","scslog1.log"))
sfi = normpath(joinpath(pathof(EnergieUsterLGE450),"..","..","sampledata","scslog2.log"))
@show sfi
@assert isfile(sfi)

dta00 = readlines(sfi);
filter!(x->endswith(x,"7E"),dta00);
idx = map(x->findlast(": ",x)[2],dta00);
dta0 = map(i->dta00[i][idx[i]+1:end],1:length(idx));
unique!(dta0);

filter!(x->startswith(x,"7E A0"),dta0);
@show length(dta0)
#@show length.(dta0)

d = dta0[1]
length(dta0)
keep_only_longest_entry!(dta0);
length(dta0)

@show length(dta0)

d = dta0[1]
dta = map(d->hex2bytes(replace(d," "=>"")),dta0);

#check length
for d in dta
    #d = dta[1]
    l = Int(d[3])
    #@show l,length(d)
    #@show d[1:l]
    #@show d
end

ltuples = map(d->(Int(d[3]),length(d)),dta)
di = countmap(ltuples)
df = DataFrame(keys=collect(keys(di)),freq=collect(values(di)));
sort!(df,:freq,rev=true)
df[!,:freq_cumulative] = cumsum(df.freq)
df[!,:freq_cumulative_pct] = df[!,:freq_cumulative] ./maximum(df[!,:freq_cumulative])
df

########################################################################
#remove entries that are too short
########################################################################
lenv = map(x->Int(x[3]),dta)
too_short_elements = map(i->length(dta[i]) < lenv[i] +2 ,1:length(lenv))
sum(too_short_elements)
@show sum(too_short_elements)/length(too_short_elements)
@assert sum(too_short_elements)/length(too_short_elements) < 0.1
deleteat!(dta,too_short_elements);

########################################################################
#Consider ending byte
########################################################################
lenv = map(x->Int(x[3]),dta)
ending_bytes = map(i->dta[i][lenv[i]+2],1:length(lenv))
length(dta)
########################################################################
#keep only items that end on 7e
########################################################################
idx = map(i->ending_bytes[i] == 0x7e,1:length(lenv))
sum(idx)
#filter! data
dta = dta[idx]
lenv = map(x->Int(x[3]),dta)
ending_bytes = map(i->dta[i][lenv[i]+2],1:length(lenv))
########################################################################
#cut data off at 7e
########################################################################
dta = map(i->dta[i][1:lenv[i]+2],1:length(lenv))
@assert all(map(x->last(x) == 0x7e,dta))
########################################################################
#consider unique entries only
########################################################################
unique!(dta)
########################################################################
#DataFrame
########################################################################
dfframes = DataFrame(bytevector=dta)
dfframes[!,:string] = bytes2hex.(dta)
@assert all(isequal(0x7e),map(x->x[1],dfframes.bytevector))
@assert all(isequal(0xa0),map(x->x[2],dfframes.bytevector))
lenv = map(x->Int(x[3]),dta)
ending_bytes = map(i->dta[i][lenv[i]+2],1:length(lenv))
dfframes[!,:length] = lenv
@assert length(unique(lenv)) == 1
########################################################################
#sort
########################################################################
sort!(dfframes,:string)
########################################################################
#split integer to columns
########################################################################
dfframes_int = deepcopy(dfframes)
add_columns!(dfframes_int)

########################################################################
#split bytes to columns
########################################################################
dfframes_bytes = deepcopy(dfframes)
add_columns_hex!(dfframes_bytes)

CSV.write(raw"C:\temp\dfframes_int.csv",dfframes_int)
CSV.write(raw"C:\temp\dfframes_bytes.csv",dfframes_bytes)
