# (Airbus A380) Multi-Function Display
# Narendran Muraleedharan (c) 2014

# NOTE - Timer not required as everything is activated by click events

var mfd = {
	new: func() {
		
	},
	showDlg: func {
		if(getprop("sim/instrument-options/canvas-popup-enable")) {
		    var dlg = canvas.Window.new([400, 512], "dialog");
		    dlg.setCanvas(me.display);
		}
	}
};
