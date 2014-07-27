# (Airbus A380) Multi-Function Display
# Narendran Muraleedharan (c) 2014

# NOTE - Timer not required as everything is activated by click events

# Object Types --> click, textbox, label

var font_mapper = func(family, weight)
{
	if( family == "Liberation Sans" and weight == "normal" )
		return "LiberationFonts/LiberationSans-Regular.ttf";
};

var generator = {
	gen_click: func(object, svg_element) return func {
		svg_element.addEventListener("click", func {
			object.function();
		});
	},
	gen_textbox: func(object, svg_element, my_modes) return func {
		 # FIXME
	},
	gen_label: func(object, svg_element, my_modes) return func {
		# FIXME
	}
}

var mfd = {
	activePage: "",
	activeMenu: "",
	pages: {},
	menus: {},
	pageObjects: nil,
	permObjects: nil,
	menuObjects: nil,
	new: func(placement) {
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
		
		return t;
	},
	init: func(modes) {
	
		me.modes = modes;
	
		# Load Permananent Section
		canvas.parsesvg(me.permObjects, me.modes.path, {'font-mapper':font_mapper});
		# Cache SVG Objects for use and load functions
		foreach(var svg_object; me.modes.objects) {
			me.modes.svg[svg_object] = me.permObjects.getElementById(svg_object);
		}
		# foreach(var svg_object; me.modes.widgets) {
		# 	foreach(var element; svg_object.elements) {
		# 		me.obj_setfunc[svg_object.type](svg_object, me.modes.svg[element], me.modes);
		# 	}
		# }
		
		me.modes.load();
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

var capt_mfd = mfd.new("mfd.l"); # Captain's side MFD
var fo_mfd = mfd.new("mfd.r"); # First Officer's side MFD
print("Airbus Multi-function Displays Initialized");
