# ECAM Systems Display - Permanent Data Zone and ATC Mailbox Area
# Narendran M (c) 2014

sd.pages["pdz"] = {
	path: "/Aircraft/A380/Models/Instruments/SD/pdz/pdz.svg",
	svg: {},
	objects: ["tat", "sat", "time", "gw", "gwcg", "fob"],
	load: func {
		# Don't do anything
	},
	update: func {
	
		var sat = getprop("/environment/temperature-degc");
		
		# Total air temperature from http://en.wikipedia.org/wiki/Total_air_temperature
		# Usually, TAT is measured and SAT is calculated but the /environment tree gives the actual (static) air temperature, the aircraft doesn't have any temperature instrumentation.
		var mach = getprop("/velocities/mach");
		var gamma = 1.4; # Ratio of Specific Heats of dry air (Cp/Ct)
		var tat = ((sat+273.15)*(1 + (((gamma - 1)*(mach*mach))/2))-273.15);
	
		if(tat >= 0) {
			me.svg["tat"].setText(sprintf("+%2.0f", tat)); # Show the + sign
		} else {
			me.svg["tat"].setText(sprintf("%2.0f", tat));
		}
		
		if(sat >= 0) {
			me.svg["sat"].setText(sprintf("+%2.0f", sat)); # Show the + sign
		} else {
			me.svg["sat"].setText(sprintf("%2.0f", sat));
		}
		
		me.svg["time"].setText(sprintf("%s GPS", getprop("/sim/time/gmt-string")));
		
		me.svg["gw"].setText(sprintf("%6.0f", getprop("/fdm/jsbsim/inertia/weight-lbs")*LB2KG));
		me.svg["gwcg"].setText(sprintf("%2.1f", (getprop("/fdm/jsbsim/inertia/cg-x-in")-1350)*0.15));
		me.svg["fob"].setText(sprintf("%6.0f", getprop("/consumables/fuel/total-fuel-kg")));
	}
};
