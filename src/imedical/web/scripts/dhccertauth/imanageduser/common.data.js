function ajaxDATA() {
	var data = {
		OutputType: arguments[0],
		Class: arguments[1],
		Method: arguments[2]
	};

	for (var i = 3; i < arguments.length; i++) {
		data['p' + (i - 2)] = arguments[i];
	}

	return data;
}

function ajaxPOSTSync(data, onSuccess, onError) {
	var ret = "";
	$.ajax({
		type: 'POST',
		dataType: 'text',
		url: '../CA.Ajax.Common.cls',
		async: false,
		cache: false,
        global:false,
		data: data,
		success: function (ret) {
			if (!onSuccess) {}
			else {
				onSuccess(ret);
			}
		},
		error: function (ret) {
			if (!onError) {}
			else {
				onError(ret);
			}
		}
	});
}
