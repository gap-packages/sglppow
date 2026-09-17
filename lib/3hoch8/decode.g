#############################################################################
##
#W  decode.g                The SglPPow package
##
##  Unpacking the data of the groups of order 3^8, written by
##  etc/encode-3hoch8.py, which describes the format.
##
##  A group is given by the 84 exponents of its pc presentation, held as a
##  string of digits '0'..'2'; consecutive groups of a layer differ in 1.9 of
##  them on average, so a layer stores the exponents of its first group and
##  then only what changes.  Reading a group means replaying those changes
##  from the preceding checkpoint.
##

# number of exponents of each of the 35 relations of a pc presentation on 8
# generators: the 7 powers, then the commutators [g_j,g_i] ordered by (i,j).
# A relation with none of them is trivial for every group of this order.
BindGlobal( "SGLPPOW_3HOCH8_NTRITS",
  [ 7,6,5,4,3,2,1, 6,5,4,3,2,1,0, 5,4,3,2,1,0, 4,3,2,1,0, 3,2,1,0, 2,1,0, 1,0, 0 ] );

BindGlobal( "SGLPPOW_3HOCH8_CKPT", 256 );

# value of a symbol of the change stream, indexed by INT_CHAR( <symbol> ) + 1
BindGlobal( "SGLPPOW_3HOCH8_SYM", [] );

# the increments a header symbol stands for, indexed by its value + 1; the
# one value without an entry, 62, introduces a group changing in more than 5
# positions, which is spelled out
BindGlobal( "SGLPPOW_3HOCH8_HDR", [] );

BindGlobal( "SGLPPOW_3HOCH8_ESC", 62 );

CallFuncList( function()
    local alpha, i, at, k, bits;

    alpha := "()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    for i in [ 1 .. Length( alpha ) ] do
        SGLPPOW_3HOCH8_SYM[ INT_CHAR( alpha[i] ) + 1 ] := i - 1;
    od;

    at := 0;
    for k in [ 1 .. 5 ] do
        for bits in [ 0 .. 2^k - 1 ] do
            SGLPPOW_3HOCH8_HDR[ at + bits + 1 ] :=
                List( [ 0 .. k-1 ], i -> 1 + QuoInt( bits, 2^i ) mod 2 );
        od;
        at := at + 2^k;
    od;
end, [] );

# the 22 rank/class layers, as far as they have been read
BindGlobal( "SGLPPOW_3HOCH8_DATA", [] );

BindGlobal( "SGLPPOW_3HOCH8_LAYER",
function( j, n, base, var, ckpos, ckstate, data )
    SGLPPOW_3HOCH8_DATA[j] := rec( n := n, base := base, var := var,
        ckpos := ckpos, ckstate := ckstate, data := data,
        idx := 1, pos := 1, state := ShallowCopy( base ) );
end );

# move <r> from the group it holds to the next one
BindGlobal( "SGLPPOW_3HOCH8_STEP",
function( r )
    local sym, data, state, var, pos, h, inc, k, m, p, e;

    sym := SGLPPOW_3HOCH8_SYM;
    data := r.data;
    state := r.state;
    var := r.var;
    pos := r.pos;

    h := sym[ INT_CHAR( data[pos] ) + 1 ];
    pos := pos + 1;
    if h = SGLPPOW_3HOCH8_ESC then
        k := sym[ INT_CHAR( data[pos] ) + 1 ];
        pos := pos + 1;
        for m in [ 1 .. k ] do
            p := var[ sym[ INT_CHAR( data[pos] ) + 1 ] + 1 ];
            e := INT_CHAR( state[p] ) - 47 + sym[ INT_CHAR( data[pos+1] ) + 1 ];
            pos := pos + 2;
            if e > 2 then e := e - 3; fi;
            state[p] := CHAR_INT( e + 48 );
        od;
    else
        inc := SGLPPOW_3HOCH8_HDR[ h + 1 ];
        for m in [ 1 .. Length( inc ) ] do
            p := var[ sym[ INT_CHAR( data[pos] ) + 1 ] + 1 ];
            pos := pos + 1;
            e := INT_CHAR( state[p] ) - 48 + inc[m];
            if e > 2 then e := e - 3; fi;
            state[p] := CHAR_INT( e + 48 );
        od;
    fi;

    r.pos := pos;
    r.idx := r.idx + 1;
end );

#############################################################################
##
#F  SGLPPOW_3HOCH8_CODE( <j>, <i> )  . pc group code of group <i> of layer <j>
##
BindGlobal( "SGLPPOW_3HOCH8_CODE",
function( j, i )
    local r, c, state, w, at, x, k, m, code, base;

    r := SGLPPOW_3HOCH8_DATA[j];

    # replay the changes, starting at a checkpoint if that is nearer
    c := QuoInt( i, SGLPPOW_3HOCH8_CKPT );
    if r.idx > i or r.idx < c * SGLPPOW_3HOCH8_CKPT then
        if c = 0 then
            r.idx := 1;
            r.pos := 1;
            r.state := ShallowCopy( r.base );
        else
            r.idx := c * SGLPPOW_3HOCH8_CKPT;
            r.pos := r.ckpos[c] + 1;
            r.state := ShallowCopy( r.ckstate[c] );
        fi;
    fi;
    while r.idx < i do
        SGLPPOW_3HOCH8_STEP( r );
    od;

    # assemble the tails of the relations, then the code, as CodePcgs does
    state := r.state;
    at := 1;
    w := [];
    for k in [ 1 .. 35 ] do
        x := 0;
        for m in [ 1 .. SGLPPOW_3HOCH8_NTRITS[k] ] do
            x := 3 * x + INT_CHAR( state[at] ) - 48;
            at := at + 1;
        od;
        w[k] := x;
    od;

    code := 0;
    base := 1;
    for k in [ 1 .. 35 ] do
        if w[k] <> 0 then code := code + base; fi;
        base := 2 * base;
    od;
    for k in [ 1 .. 35 ] do
        if w[k] <> 0 then
            code := code + base * w[k];
            base := base * 6561;
        fi;
    od;
    return code;
end );

#E  decode.g . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
