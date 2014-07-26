# (Airbus A380) Multi-Function Display
# Narendran Muraleedharan (c) 2014

# NOTE - Timer not required as everything is activated by click events

# Object Types --> click, textbox, label

var font_mapper = func(family, weight)
{
	if( family == "Liberation Sans" and weight == "normal" )
		return "LiberationFonts/LiberationSans-Regular.ttf";
};

var mfd = {
	obj_setfunc: {
		"click": func(object, svg_element, parent) {
			# if(svg_element.getVisible()) {
			svg_element.addEventListener("click", func { object.function(me, parent)});
			# }
		},
		"textbox": func(object, svg_element, parent) {
			#FIXME
		},
		"label": func(object, svg_element, parent) {
			#FIXME
		}
	},
	activePage: "",
	activeMenu: "",
	pages: {},
	menus: {},
	pageObjects: nil,
	permObjects: nil,
	menuObjects: nil,
	new: func(placement, modes) {
		var t = {parents:[mfd]};
		
		t.display = canvas.new({
			"name":			"MFD Display",
			"size":			[800, 1024],
			"view":			[800, 1024],
			"mipmapping":	1
		});
		
		t.display.addPlacement({"node": placement});
		t.pageObjects = t.display.createGroup();	# SVG Objects for pages
		t.permObjects = t.display.createGroup();	# SVG Objects for mode selector dropdown
		t.menuObjects = t.display.createGroup();	# SVG Objects for menu bar
		
		t.modes = modes;
		
		# Load Permananent Section
		canvas.parsesvg(t.permObjects, t.modes.path, {'font-mapper':font_mapper});
		# Cache SVG Objects for use and load functions
		foreach(var svg_object; t.modes.objects) {
			t.modes.svg[svg_object] = t.permObjects.getElementById(svg_object);
		}
		foreach(var svg_object; t.modes.widgets) {
			t.obj_setfunc[svg_object.type](svg_object, t.modes.svg[svg_object.element], t.modes);
		}
		
		t.modes.load();
		
		return t;
	},
	loadPage: func(page) {
		if((me.pages[page] != nil) and (page != me.activePage)) { # Canvas page is available
			me.pageObjects.removeAllChildren();
			me.loadMenu(me.pages[page].menu);
			canvas.parsesvg(me.pageObjects, me.pages[page].path, {'font-mapper':font_mapper});
			# Cache SVG Objects for use
			foreach(var svg_object; me.pages[page].objects) {
				me.pages[page].svg[svg_object] = me.pageObjects.getElementById(svg_object);
			}
			foreach(var svg_object; me.pages[page].widgets) {
				obj_setfunc[svg_object.type](svg_object, me.pages[page].svg[svg_object.element], me.pages[page]);
			}
			me.activePage = page;
			me.pages[page].load();
		} else {
			print("[MFD] Invalid page ID");
		}
	},
	loadMenu: func(menu) {
		if((me.menus[menu] != nil) and (menu != me.activeMenu)) { # Canvas page is available
			me.menuObjects.removeAllChildren();
			canvas.parsesvg(me.menuObjects, me.menus[menu].path, {'font-mapper':font_mapper});
			# Cache SVG Objects for use
			foreach(var svg_object; me.menus[menu].objects) {
				me.menus[menu].svg[svg_object] = me.menuObjects.getElementById(svg_object);
			}
			foreach(var svg_object; me.menus[menu].widgets) {
				obj_setfunc[svg_object.type](svg_object, me.menus[menu].svg[svg_object.element], me.menus[menu]);
			}
			me.activeMenu = menu;
			me.menus[menu].load();
		}
	},
	showDlg: func {
		if(getprop("sim/instrument-options/canvas-popup-enable")) {
		    var dlg = canvas.Window.new([400, 512], "dialog");
		    dlg.setCanvas(me.display);
		}
	}
};

var capt_mfd = mfd.new("mfd.l", modes); # Captain's side MFD
var fo_mfd = mfd.new("mfd.r", modes); # First Officer's side MFD
print("Airbus Multi-function Displays Initialized");
