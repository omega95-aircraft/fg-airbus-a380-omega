# (Airbus A380) MFD Modes Dropdown Menu
# Narendran Muraleedharan (c) 2014

var modes = {
	path: "/Aircraft/A380/Models/Instruments/MFD/modes.svg", # SVG Path
	svg: {}, # SVG Elements (must be empty)
	options: ["fms1", "fms2", "atc_com", "surv", "fcu_bkup"],
	objects: ["fms_mode_static", "dropdown", "fms1_click", "fms2_click", "atc_com_click", "surv_click", "fcu_bkup_click", "flightnum", "fms_mode_box", "fms_mode_text", "msg_list"],
	widgets: [ # Widget Objects
		{
			elements: ["fms_mode_static", "fms_mode_box", "fms_mode_text"],
			type: "click",
			function: return func() {
				me.svg["dropdown"].show();
				foreach(var obj; me.options) {
					me.svg[obj~"_click"].show();
				}
				me.svg["fms_mode_box"].setColorFill(220,220,220);
				print("fms_mode_static - Function Called");
			}
		},
		{
			elements: ["fms1_click"],
			type: "click",
			function: return func() {
				# Open dropdown menu
				my_modes.svg["dropdown"].hide();
				foreach(var obj; my_modes.options) {
					my_modes.svg[obj~"_click"].hide();
				}
				my_modes.svg["fms_mode_box"].setColorFill(80,80,80);
				print("fms1_click - Function Called");
				my_modes.svg["fms_mode_text"].setText("FMS 1");
				# Set Mode to FMS 1
			}
		}
	],
	new: func() {
		var t = {parents:[modes]};
		return t;
	}
};

capt_mfd.init(modes);
fo_mfd.init(modes);
