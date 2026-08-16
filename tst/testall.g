LoadPackage("sglppow");
exclude := [];
if not IsBound(SGLPPOW_AVAILABLE_PHOCH7) then
    # lib/phoch7/sgl-p7.g was not read, whichever way we register
    Add(exclude, "order_p_7.tst");
fi;

TestDirectory(DirectoriesPackageLibrary("sglppow", "tst"),
    rec(exitGAP := true, exclude := exclude));
FORCE_QUIT_GAP(1);
