# the codes of the families we have constructed so far, and the number of
# groups in each family; both indexed by the prime and then the family
BindGlobal( "SGLPPOW_PHOCH7_CODES", [] );
BindGlobal( "SGLPPOW_PHOCH7_COUNTS", [] );

# the orders we cover, and how many groups we have of each
BindGlobal("SGLPPOW_AVAILABLE_PHOCH7", function( size )
    local f, p, n;
    f := Factors(size);
    p := f[1];
    n := Length(f);
    if Length(Set(f)) <> 1 or p <= 11 or n <> 7 then
        return fail;
    fi;
    return rec (
        p := p,
        n := n,
        number := 3 * p ^ 5 + 12 * p ^ 4 + 44 * p ^ 3 + 170 * p ^ 2
               # + 707 * p + 2
                + 707 * p + 2455
                + (4 * p ^ 2 + 44 * p + 291) * Gcd((p-1), 3 )
                + (p ^ 2 + 19 * p + 135) * Gcd((p-1), 4 )
                + (3 * p + 31) * Gcd((p-1), 5 )
                + 4 * Gcd((p-1), 7 )
                + 5 * Gcd((p-1), 8 ) + Gcd((p-1), 9 )
       );
end);

# Method for SmallGroup(size, i):
BindGlobal("SGLPPOW_GROUP_PHOCH7", function( size, i, inforec )
    local p, l, j, k, L, F;
    p := inforec.p;

    if i > inforec.number then
        Error("there are just ",inforec.number," groups of order ",size );
    fi;

    if not IsBound( SGLPPOW_PHOCH7_CODES[p] ) then
        SGLPPOW_PHOCH7_CODES[p] := [];
        SGLPPOW_PHOCH7_COUNTS[p] := [];
    fi;

    if not IsBound(SGLPPOW_PHOCH7_COUNTS[p][1]) then
        L := LiePRingByData(7, LIE_DATA[7][1] );
        l := NumberOfLiePRingsInFamily(L);
        SGLPPOW_PHOCH7_COUNTS[p][1] := EvaluatePorcPoly(l, p);
    fi;

    j := 1;
    k := i;
    while k > SGLPPOW_PHOCH7_COUNTS[p][j] do
        k := k-SGLPPOW_PHOCH7_COUNTS[p][j];
        j := j+1;
        if not IsBound(SGLPPOW_PHOCH7_COUNTS[p][j]) then
            L := LiePRingByData(7, LIE_DATA[7][j] );
            l := NumberOfLiePRingsInFamily(L);
            SGLPPOW_PHOCH7_COUNTS[p][j] := EvaluatePorcPoly(l, p);
        fi;
        if not IsInt(SGLPPOW_PHOCH7_COUNTS[p][j]) then
            L := LiePRingByData(7, LIE_DATA[7][j]);
            SGLPPOW_PHOCH7_CODES[p][j] := LiePRingsInFamily(L, p, "code");
            SGLPPOW_PHOCH7_COUNTS[p][j] := Length(SGLPPOW_PHOCH7_CODES[p][j]);
        fi;
    od;

    if IsBound( SGLPPOW_PHOCH7_CODES[p][j] ) then
        return PcGroupCode( SGLPPOW_PHOCH7_CODES[p][j][k], size );
    fi;

    if SGLPPOW_PHOCH7_COUNTS[p][j] > p then
        Print("constructing a batch of ",SGLPPOW_PHOCH7_COUNTS[p][j]," groups ");
        Print("... this may take a while \n");
    fi;

    L := LiePRingByData(7, LIE_DATA[7][j]);
    SGLPPOW_PHOCH7_CODES[p][j] := LiePRingsInFamily(L, p, "code");
    return PcGroupCode( SGLPPOW_PHOCH7_CODES[p][j][k], size );
end);

#
# hook us up on the layer level
#

if IsBound(SmallGroupsAddLayer) then

# SmallGrp 1.7 and up: describe the layer and let SmallGrp place it
SmallGroupsAddLayer( rec(
    name := "SglPPow p^7",
    available := SGLPPOW_AVAILABLE_PHOCH7,
    group := SGLPPOW_GROUP_PHOCH7,
    information := SGLPPOW_INFO ) );

else

# SmallGrp before 1.7: claim the slots and fill the arrays by hand

# Get the next available "layer" id (the built-in library
# consists of 11 layers, but other packages may already have
# added further layers).
BindGlobal( "SGLPPOW_PHOCH7_LIB_ID", SGLPPOW_3HOCH8_LIB_ID + 1 );

# Determine where to add our new lookup functions
BindGlobal( "SGLPPOW_PHOCH7_FUNC_ID", SGLPPOW_3HOCH8_FUNC_ID + 1 );

# need to adjust this, as otherwise an error is produced
SMALL_AVAILABLE_FUNCS[11] := function( size )
    local  p;
    p := FactorsInt( size );
    if Length( p ) <> 7 or p[1] = 2 or p[1] > 11 or Length(Set(p)) > 1  then
        return fail;
    fi;
    return rec( func := 26, lib := 11, p := p[1] );
end;

# meta data on small groups data we provide
SMALL_AVAILABLE_FUNCS[SGLPPOW_PHOCH7_LIB_ID] := function( size )
    local r;
    r := SGLPPOW_AVAILABLE_PHOCH7( size );
    if r = fail then
        return fail;
    fi;
    r.lib := SGLPPOW_PHOCH7_LIB_ID;
    r.func := SGLPPOW_PHOCH7_FUNC_ID;
    return r;
end;

# meta data on IdGroup functionality we provide
ID_AVAILABLE_FUNCS[SGLPPOW_PHOCH7_LIB_ID] := function( size )
    # Three possible implementations:

    # 1. No IdGroup functionality at all:
    return fail;

    # 2. IdGroup provided for all groups:
    #return SMALL_AVAILABLE_FUNCS[SGLPPOW_PHOCH7_LIB_ID];

    # 3. IdGroup provided for a subset of order
    #if size in [ 12345, 67890 ] then
    #  return SMALL_AVAILABLE_FUNCS[SGLPPOW_PHOCH7_LIB_ID];
    #fi;

end;

# Method for SmallGroup(size, i):
SMALL_GROUP_FUNCS[ SGLPPOW_PHOCH7_FUNC_ID ] := SGLPPOW_GROUP_PHOCH7;

# Method which selects a subset of all those groups with
# a certain combination of properties.
# A default method can be used; but more user friendly would be
# to install something custom which e.g. takes care of filtering
# the abelian groups, and which also knows that all groups
# of order p^n are nilpotent.
SELECT_SMALL_GROUPS_FUNCS[ SGLPPOW_PHOCH7_FUNC_ID ] := SELECT_SMALL_GROUPS_FUNCS[ 11 ];

# Optional: Method for IdGroup(size, i).
#ID_GROUP_FUNCS[ SGLPPOW_PHOCH7_FUNC_ID ] := function( G, inforec )
#    Error("TODO");
#end;

# Method for SmallGroupsInformation(size):
SMALL_GROUPS_INFORMATION[ SGLPPOW_PHOCH7_FUNC_ID ] := SGLPPOW_INFO;

fi;
