gap> NumberSmallGroups(3^8);
1396077
gap> SmallGroup(3^8, 1);
<pc group of size 6561 with 8 generators>
gap> SmallGroup(3^8, 1000000);
<pc group of size 6561 with 8 generators>
gap> SmallGroup(3^8, 1396077);
<pc group of size 6561 with 8 generators>

# validate bounds check
gap> SmallGroup(3^8, 1396078);
Error, there are just 1396077 groups of order 6561
