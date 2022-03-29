LoadPackage("sglppow");
exclude := [];
if layer_phoch7 = false then
    Add(exclude, "order_p_7.tst");
fi;

TestDirectory(DirectoriesPackageLibrary("sglppow", "tst"),
    rec(exitGAP := true, exclude := exclude));
FORCE_QUIT_GAP(1);
