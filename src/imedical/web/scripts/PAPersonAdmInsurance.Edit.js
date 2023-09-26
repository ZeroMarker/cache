// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPersonAdmInsurance_Edit"];
if (parent.frames["papersonadminsurance_edit"]) {
frm.elements['TFRAME'].value=window.parent.name;
	}
function DocumentLoadHandler() {
	
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}
	
}

function UpdateClickHandler() {
		var frm = document.forms["fPAPersonAdmInsurance_Edit"];
		var obj=frm.elements['TWKFLI'];
		//if (!(fPAPersonAdmInsurance_Edit_submit())) return false
		if (obj.value!="") obj.value-=1;
		
		return update1_click()
		}
document.body.onload = DocumentLoadHandler;




	