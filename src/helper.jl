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
    @assert length(unique(dfframes.length)) == 1
    ll = dfframes.length[1]
    for i=1:ll+2
        colname = string("int_",i)
        dfframes[!,colname] = map(x->x[i],dfframes.bytevector)
    end
    return nothing
end 

export add_columns_hex!
function add_columns_hex!(dfframes)
    @assert length(unique(dfframes.length)) == 1
    ll = dfframes.length[1]
    for i=1:ll+2
        colname = string("int_",i)
        dfframes[!,colname] = map(x->bytes2hex(x[i]),dfframes.bytevector)
    end
    return nothing
end 
