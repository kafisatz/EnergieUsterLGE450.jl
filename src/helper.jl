export keep_only_longest_entry!
function keep_only_longest_entry!(dta0)
    #keep only 'longest' version
    for d in dta0
        idx00 = map(ddd -> !isequal(d,ddd) && startswith.(ddd,d),dta0)
        #sum(map(ddd -> startswith.(ddd,d),dta0))
        #sum(idx00)
        #length.(dta0[idx00])
        #length(d)
        if sum(idx00) > 0
            # -> another entry starts with 'd'
            deleteat!(dta0,dta0 .==d)
        end
    end
    return nothing 
end 


export add_columns!
function add_columns!(dfframes)
    #@assert length(unique(dfframes.length)) == 1
    ll = dfframes.length[1]
    for i=1:ll+2
        colname = string("int_",i)
        dfframes[!,colname] = map(x->length(x) >= i ? x[i] : 0,dfframes.bytevector)
    end
    return nothing
end 

export add_columns_hex!
function add_columns_hex!(dfframes)
    #@assert length(unique(dfframes.length)) == 1
    ll = dfframes.length[1]
    for i=1:ll+2
        colname = string("int_",i)
        dfframes[!,colname] = map(x->length(x) >= i ? bytes2hex(x[i]) : bytes2hex(0x0) ,dfframes.bytevector)
    end
    return nothing
end 


export space_delimited_hex_string
function space_delimited_hex_string(x::T) where {T <: AbstractString}
    l = length(x)
    @assert iseven(l)
    if iszero(l)
        return x
    end
    return join(map(i->x[2*i+1:2*i+2],0:div(l,2)-1)," ")
end