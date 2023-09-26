// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	var obj=document.getElementById('CantOverBook');
	if ((obj)&&(obj.value=="Y")) {
		var obj2=document.getElementById('Overbook');
		if (obj2) {
			obj2.disabled=true;
			obj2.className="disabledField";
		}
		var obj2=document.getElementById('OverbookBy');
		if (obj2) {
			obj2.disabled=true;
			obj2.className="disabledField";
		}
	}
	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.onblur=HospBlurHandler;
}

function DocumentUnLoadHandler() {
	if (window.opener.top.frames["TRAK_main"].frames["RBBulkTransEdit"]) window.opener.top.frames["TRAK_main"].frames["RBBulkTransEdit"].FindClickHandler()
}

/*function ResLookUp(str) {
	var obj=document.getElementById('Resource');
}*/

function LocLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Resource');
	if (obj) obj.value=""
	var obj=document.getElementById('Location');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('HOSPDesc')
	if (obj) obj.value=lu[4];
	var obj=document.getElementById('HOSPId')
	if (obj) obj.value=lu[7];
}

/*SB, 24527
function SessionTypeLookUp(str) {
	strx = str.replace("||", "?")
	str = strx.replace("||", "?")
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('SessionId');
	if (obj) obj.value=lu[3];
}
*/

//SB, 27605
function SessionTypeLookUp(str) {
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('SessionId');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('sesstype');
	if (obj) obj.value=lu[0] + " (" + lu[2] + "-" + lu[3] + ") " + lu[4];
	;
}

function HospLookup(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('HOSPId');
	if (obj) obj.value=lu[1];

	return;
}

function HospBlurHandler() {
	var obj=document.getElementById('HOSPDesc');
	var objid=document.getElementById('HOSPId');
	if ((objid)&&(obj)&&(obj.value=="")) objid.value="";
}

document.body.onunload = DocumentUnLoadHandler;
document.body.onload = DocumentLoadHandler;