// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var LookUpFieldName="";

var objTblName=document.getElementById("TblName");
var objFldName=document.getElementById("FldName");
var objFieldName=document.getElementById("FieldName");
var objSimpleDSS=document.getElementById("SimpleDSS");
var objLUFldName=document.getElementById('ld1489iFldName');

function BodyLoadHandler() {
	
	if (objLUFldName) objLUFldName.onclick=luFldName;

	if (objFldName) {
		objFldName.onkeydown=luFldName;
		objFldName.onchange=UpdateFieldName;
	}
	var fieldobj=document.getElementById("FieldName")
	if (fieldobj) {
		fieldobj.readOnly=true;
	}
}

function luFldName() {
	var TblName='';
	var FldName='';
	var SimpleDSS='';
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (objTblName) TblName=objTblName.value;
		if (objFldName) FldName=objFldName.value;
		if (objSimpleDSS) SimpleDSS=objSimpleDSS.value;
		LookUpFieldName="FldName";
		//var url='websys.dssrule.lookup.csp?classname=' + TblName + '&sqlfieldname=' + FldName;
		var url='websys.dssrule.lookup.csp?classname=' + TblName + '&sqlfieldname=' + FldName + '&SimpleDSS=' + SimpleDSS;
		websys_lu(url,true,'');
		return websys_cancel();
	}
}

function AddItem(str) {
	var lu = str.split("^");

	if (LookUpFieldName=="FldName") {
		if (objFldName) objFldName.value = lu[0];
		if (objFieldName) objFieldName.value = lu[1];
	}
}


function DoNothing() {
	return false;
}

var objID=document.getElementById("ID");
var lnk=document.getElementById("new1");

if ((lnk)&&(objID.value=="")) {
	lnk.disabled=true;
	lnk.className='disabledField';
	lnk.style.cursor='default';
	lnk.onclick=DoNothing;
	var imgs=lnk.getElementsByTagName("IMG");
	if (imgs[0]) imgs[0].style.visibility="hidden";
}

function BodyUnloadHandler(e) {
	if ((self == top)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}


function LookUpSQLFieldName2(str) {
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("FldName")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("FieldName")
	if (obj) obj.value = lu[1];
}


function UpdateFieldName() {
	var str="";
	if (objFldName) {
		str=objFldName.value
		if (str.length == 0){
			if (objFieldName) objFieldName.value = "";
		}
	}
}

document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnloadHandler;
