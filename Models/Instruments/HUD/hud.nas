# (Airbus A380) Heads Up Display
# Narendran M (c) 2014

var placement_l = "hud.l";
var placement_r = "hud.r";
var svgPath = "/Aircraft/A380/Models/Instruments/HUD/hud.svg";

# Define properties for interface
var myProps = {
	'pitch':	"/orientation/pitch-deg",
	'roll':		"/orientation/roll-deg",
	'heading':	"/instrumentation/heading-indicator/indicated-heading-deg",
	'airspeed':	"/instrumentation/airspeed-indicator/indicated-airspeed-kt",
	'mach':		"/velocities/mach",
	'altitude':	"/instrumentation/altimeter/indicated-altitude-ft",
	'qnh':		"/instrumentation/altimeter/setting-inhg",
	'alpha':	"/orientation/alpha-deg",
	'sideslip':	"/orientation/side-slip-deg",
	'rollrate':	"/orientation/roll-rate-degps",
	'ap_alt':	"/flight-management/fcu-values/alt",
	'ap_spd':	"/flight-management/fcu-values/ias",
	'vertspd':	"/velocities/vertical-speed-fps",
	'radaralt':	"/instrumentation/radar-altimeter/radar-altitude-ft"
};

# Adjust stall speed and maximum flap retraction speeds
var myParams = {
	stall: 125,
	flaps: {
		prop:	"/controls/flight/flaps",
		speeds:	[
			{setting: 	0.0000,		speed:	263},
			{setting:	0.2424,		speed:	222},
			{setting:	0.5151,		speed:	220},
			{setting:	0.7878,		speed:	196},
			{setting:	1.0000,		speed:	182}
		]
	}
};

var hud = {
	new: func(obj_name, interface_props, svg_path, flight_params) {
		var t = {parents:[hud]};
		
		t.display = canvas.new({
			"name": "HUD",
			"size": [1024, 740],
			"view": [1024, 740],
			"mipmapping": 1
		});
		
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		t.props = interface_props;
		t.params = flight_params;
		t.display.addPlacement({"node": obj_name});
		t.symbols = t.display.createGroup();
		
		canvas.parsesvg(t.symbols, svg_path, {'font-mapper': font_mapper});
		t.display.setColorBackground(0.36, 1, 0.3, 0.02);
		
		# t.symbols.getElementById("wind_arrow").updateCenter();
		
		# Set Clips
		## Central Horizon box
		t.symbols.getElementById("horizon_heading").set("clip", "rect(115,205,80,220)");
		t.symbols.getElementById("horizon_lines").set("clip", "rect(115,205,80,220)");
		## Speed Tape box - horizontal clipping is not important anymore
		t.symbols.getElementById("spd_tape").set("clip", "rect(200,0,220,0)");
		t.symbols.getElementById("stall_tape").set("clip", "rect(200,0,220,0)");
		t.symbols.getElementById("flaps_tape").set("clip", "rect(200,0,220,0)");
		## Altitude Tape box
		t.symbols.getElementById("alt_tape_text").set("clip", "rect(200,0,220,0)");
		## Altitude Marker Tape boxes
		t.symbols.getElementById("alt_tape_markers_top").set("clip", "rect(360,0,220,0)");
		t.symbols.getElementById("alt_tape_markers_bottom").set("clip", "rect(200,0,400,0)");
		## Alitude 100s Tape box
		t.symbols.getElementById("alt_tape_100s").set("clip", "rect(325,0,350,0)");
		## Vertical Speed Indicator box
		t.symbols.getElementById("vs_pointer").set("clip", "rect(230,0,250,0)");
		
		return t;
	},
	init: func {
		me.update(0);
	},
	update: func(UPDATE_INTERVAL) {
		
		
		
		settimer(func me.update(UPDATE_INTERVAL), UPDATE_INTERVAL);
	}
};

var capt_hud = hud.new(placement_l, myProps, svgPath, myParams);

setlistener("sim/signals/fdm-initialized", func {
	capt_hud.init();
	print("Heads Up Displays Initialized");
});
