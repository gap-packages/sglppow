gap> START_TEST("");

#
gap> NumberSmallGroups(3^8);
1396077
gap> SmallGroup(3^8, 1000000);
<pc group of size 6561 with 8 generators>
gap> NumberSmallGroups(17^7);
5546909
gap> SmallGroup(17^7, 5000);
constructing a batch of 1156 groups ... this may take a while 
<pc group of size 410338673 with 7 generators>
gap> NumberSmallGroups(101^7);
32826263845

#
gap> STOP_TEST( "", 1 );
