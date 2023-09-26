// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//md script redeveloped as per spec 46433

var frm = document.forms["fPAExemption_Edit"];
if (parent.frames["paex_edit"]) {
frm.elements['TFRAME'].value=window.parent.name;
	}
function DocumentLoadHandler() {
	
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}
	var obj = document.getElementById("delete1");
	if (obj) {
		obj.onclick = DeleteClickHandler;
		if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;
	}
	
}

function UpdateClickHandler() {
		var frm = document.forms["fPAExemption_Edit"];
		var obj=frm.elements['TWKFLI'];
		if (obj.value!="") obj.value-=1;
		
		return update1_click()
		}

function DeleteClickHandler() {
		var frm = document.forms["fPAExemption_Edit"];
		var obj=frm.elements['TWKFLI'];
		if (obj.value!="") obj.value-=1;
		
		return delete1_click()
		}
document.body.onload = DocumentLoadHandler;




	