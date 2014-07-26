var alerts = {
	colors: {
		'red':		[0.85,	0,		0],		# Failures requiring immediate action
		'amber':	[1,		0.55,	0],		# Failures requiring awareness but not immediate action
		'green':	[0,		0.85,	0],		# Memo, Checked in a normal checklist
		'white':	[0.85,	0.85,	0.85],	# Conditional Items, completed actions in procedure
		'cyan':		[0,		0.85,	0.85],	# Limitations, unchecked items in a checklist
		'magenta':	[0.85,	0,		0.85],	# Specific Memo (TO, LDG etc.)
		'gray':		[0.55,	0.55,	0.55]	# Invalid items
	},
	mode: '', # CHECKLIST, PROCEDURES, LIMITATIONS, ABNORMAL PROC
	active_item: 0,
	items: [], # ITEM - Checklist/Procedure items
	limits: [],	# LIMIT - Limitations (displayed in white/cyan)
	memos: [],	# STRING - Memos (displayed in green)
	display: func {
	
	}
};

