// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById("CNTList")
	if (obj) {
		for (var j=0; j<obj.length; j++) {
			obj.options[j].text=obj.options[j].value
		}
	}		
}

function FindClickHandler() {
	var obj=document.getElementById("CNTList")
	var hidobj=document.getElementById("HIDCNTList")
	var TypeStr="^";
	if (obj) {
		for (var j=0; j<obj.length; j++) {
			if(obj.options[j].selected) TypeStr=TypeStr+obj.options[j].value+"^"
		}
		hidobj.value=TypeStr;
	}		
	return btnSearch_click();;
}	

function AppointmentLookup(str) {
	var lu = str.split("^");
 	obj=document.getElementById("ApptDate")
	if (obj) obj.value = lu[1];

}

window.document.body.onload=BodyLoadHandler;

var fobj=document.getElementById("btnSearch")
if(fobj) fobj.onclick=FindClickHandler;