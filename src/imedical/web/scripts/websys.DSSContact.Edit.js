// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var LookUpFieldName="";

var objStartClass=document.getElementById('StartClass');
var objEndClass=document.getElementById('EndClass');
var objLUFldPath=document.getElementById('ld1792iFldPath');
var objFldPath=document.getElementById('FldPath');

//var objFldValue=document.getElementById('FldValue');


function BodyLoadHandler() {
	
	var obj=document.getElementById("StartClass");
	if (obj) obj.onblur=StartCassBlurHandler;
	
	//if (objLUFldPath) objLUFldPath.onclick=luFldPath;

	//if (objFldPath) {
	//	objFldPath.onkeydown=luFldPath;
		//objFldPath.onchange=UpdateFldValue;
	//}	
}


function UpdateFldValue() {
	var str="";
	if (objFldPath){
		str=objFldPath.value
		if (str.length == 0){
			if (objFldValue) objFldValue.value = "";
		}
	}
}

// ab - no idea why this was done - have commented out above
/*
function luFldPath() {
	var StartClass='';
	var FldPath='';
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (objStartClass) StartClass=objStartClass.value;
		if (objFldPath) FldPath=objFldPath.value;
		LookUpFieldName="FldPath";
		var url='websys.dssrule.lookup.csp?classname=' + StartClass + '&sqlfieldname=' + FldPath;
		websys_lu(url,true,'');
		return websys_cancel();
	}
}
function AddItem(str) {
	var lu = str.split("^");
	if (LookUpFieldName=="FldPath") {
		if (objFldPath) objFldPath.value = lu[1];
		if (objEndClass) objEndClass.value = lu[2];
	}
}
*/

function StartClassLookup(str) {
	var val=str.split("^");
	var obj=document.getElementById("StartClassHidden");
	if (obj) obj.value=val[1];
	var obj=document.getElementById("StartTable");
	if (obj) obj.value=val[2];
	var obj=document.getElementById("StartClassID");
	if (obj) obj.value=val[3];
	//if (obj) obj.value="DSS"+val[1].split(".")[1];
}

function FldPathLookup(str) {
	var val=str.split("^");
	var obj=document.getElementById("FldPathFull");
	if (obj)  obj.value=val[1];
	//var obj=document.getElementById("EndTable");
	//if (obj)  obj.value=val[3];
	//var obj=document.getElementById("EndClassID");
	//if (obj)  obj.value=val[4];
	var obj=document.getElementById("EndTable");
	if (obj) {
		var EndRowID=val[1].split("->")[(val[1].split("->").length-1)];
		var obj2=document.getElementById("EndClassID");
		if (obj2) {
			obj2.value=EndRowID;
		}
		if (EndRowID=="CTPCP_RowId") {
			obj.value="SQLUser.CT_CareProv";
		}
		if (EndRowID=="REFD_RowId") {
			obj.value="SQLUser.PAC_RefDoctor";
		}
	}
}

function StartCassBlurHandler() {
	var obj=document.getElementById("StartClass");
	var obj2=document.getElementById("StartClassHidden");
	if ((obj)&&(obj2)&&(obj.value=="")) obj2.value="";
}

document.body.onload=BodyLoadHandler;
