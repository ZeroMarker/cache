
//关闭窗口
function closeWindow() {
	window.opener = null;
	window.open('', '_self');
	window.close();
}

$(function () {

	var args = opener.HisTools.hislinkWindow.args;
	document.title = args.title;

	var isConfirm = false;
	$('#confirm').live('click', function () {
		isConfirm = true;
		closeWindow();
	});
	$('#cancel').live('click', function () {
		isConfirm = false;
		closeWindow();
	});

	window.onunload = function () {
		if (isConfirm) {
			if (args.confirmCallback)
				args.confirmCallback();
		} else {
			if (args.cancelCallback)
				args.cancelCallback();
		}
	};

	if (null !== args.confirmCallback) {
		$('#confirm').show();
	}
	$('#frameHIS').attr('src', args.lnk);

});
