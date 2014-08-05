var capt_mfd = mfd.new("mfd.l", "Aircraft/A380/Models/Instruments/MFD/display.svg");
var fo_mfd = mfd.new("mfd.r", "Aircraft/A380/Models/Instruments/MFD/display.svg");

capt_mfd.loadPage("menu_fms", "fms_active_init");
fo_mfd.loadPage("menu_fms", "fms_active_init");

print("Airbus Multi-Function Displays Initialized");
