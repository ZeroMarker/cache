/// DHCOPGCF.List.js

function BodyLoadHandler() {
	var obj = websys_$("desc");
	if (obj) {
		obj.onkeydown = grpDesc_KeyDown;
	}
}

function grpDesc_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var keyCode = websys_getKey(e);
	if (keyCode == 13) {
		Find_click();
	}
}

document.body.onload = BodyLoadHandler;
