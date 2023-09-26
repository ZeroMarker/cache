function BodyUnloadHandler(e) {
	if ((self == top)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}

document.body.onunload=BodyUnloadHandler;