// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function DocumentLoadHandler() {


	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

}



function UpdateClickHandler(e) {
	if (parent.frames["lower"]) {
		var frm = document.forms["fPAAdm2MaternityComplic_Edit"];
		//frm.target = "_parent"
		if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	//alert(frm.action)
	return update1_click();
}





function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld);
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}




document.body.onload = DocumentLoadHandler;
