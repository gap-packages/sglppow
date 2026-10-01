#############################################################################
##
#W    read.g                 The SglPPow package              
##

#############################################################################
##
#R  Read the install files.
##

# Method for SmallGroupsInformation(size), used by both our layers
BindGlobal( "SGLPPOW_INFO", function( size, inforec, num )
    Print( " \n");
    Print( "This database was created by Michael Vaughan-Lee (2014).\n");
end );

ReadPackage( "sglppow", "lib/3hoch8/decode.g" );
ReadPackage( "sglppow", "lib/3hoch8/sgl-6561.g" ); 


#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

