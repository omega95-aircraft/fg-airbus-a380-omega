var item = {
	color: 'white',
	req_check: 0,		# Shows Checkbox
	checked: 0,			# Shows check mark
	description: '',	# Item description
	response: '',		# Item response
	new: func {
		var t = {parents:[item]};
		return t;
	}
};
