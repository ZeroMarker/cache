// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var timerenabled=true;
var SessionId=""
function BodyLoadHandler() {
   	if (self==top) websys_reSizeT();
	
	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateClickHandler;
	
	var obj=document.getElementById("SOVRBSessionDR");
	var cobj=document.getElementById("cSession");
	if (obj){
		var list = obj.value.split("^");
		if (list[1]) {
			if (cobj) cobj.className = "clsRequired";
		} else {
			DisableField("Session");
		}
	}
	//nareason.disabled=true;
}

function SessionTypeLookUp(str) {
	var lu = str.split("^");
	SessionId=lu[2]
}

function UpdateClickHandler() {
 	if (CheckMandatoryFields()) {
		if (SessionId!="") {
			var obj=document.getElementById("SOVRBSessionDR");
			if (obj) obj.value=SessionId
		}
		return update1_click();
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lup=document.getElementById("ld1095i"+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
		fld.className = "disabledField";
	}
	if (lup) {lup.disabled = true;}
}

function CheckMandatoryFields() {
	//debugger;
	var msg="";
	SessMandatory=0;
	var obj=document.getElementById("SOVRBSessionDR");
	if (obj){
		var list = obj.value.split("^");
		if (list[1]) SessMandatory=1;
	}
	if (SessMandatory==1) {
		var obj = document.getElementById('Session');
		//alert(obj.value);
		if (obj) {
			if (obj.value=="") msg += "\'" + t['SessType'] + "\' " + t['XMISSING'] + "\n";
		} else {
		    msg += "\'" + t['SessType'] + "\' " + t['XMISSING'] + "\n";
		}

		if (msg=="") {
			return true;
		} else {
			alert(msg)
			return false;
		}
	} else {
		return true;
	}
}


//document.forms[0].target=window.opener.name;
document.body.onload = BodyLoadHandler;
