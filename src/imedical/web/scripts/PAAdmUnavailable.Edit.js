// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	var obj=document.getElementById("UNAVDateFrom");
	if (obj) obj.onblur=StartDateBlurHandler;
	
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
	var frm = document.forms["fPAAdmUnavailable_Edit"];
	if (parent.frames["paadmunavailable_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	
	var obj=frm.elements['TWKFLI'];
	if (!(fPAAdmUnavailable_Edit_submit())) return false;
	if (obj.value!="") obj.value-=1;
	
	return update1_click();
}

function DeleteClickHandler() {
	var frm = document.forms["fPAAdmUnavailable_Edit"];
	if (parent.frames["paadmunavailable_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	
	return delete1_click();
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("UNAVDateFromH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}



















document.body.onload = DocumentLoadHandler;
