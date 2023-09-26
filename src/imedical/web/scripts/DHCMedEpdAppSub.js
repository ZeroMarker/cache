
function BodyLoadHandler() {
	iniForm();
	alert("1");
	}
function iniForm() {
	s=gGetObjValue("EpdaRowid");
	alert(s);
	}


document.body.onload = BodyLoadHandler;