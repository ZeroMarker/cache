// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var LookUpFieldName="";

var objTblName=document.getElementById('TblName');
var objTblDisplayName=document.getElementById('TblDisplayName');
var objClassName=document.getElementById('ClassName')
var objLUFieldValue=document.getElementById('ld1198iFieldValue');
var objFieldValue=document.getElementById('FieldValue');
var objLUFieldID=document.getElementById('ld1198iFieldID');
var objFieldID=document.getElementById('FieldID');
var objFldId=document.getElementById('FldId');
var objFldValue=document.getElementById('FldValue');
var objSimpleDSS=document.getElementById('SimpleDSS');

function BodyLoadHandler() {
	
	if (objLUFieldID) objLUFieldID.onclick=luFieldID;

	if (objFieldID) {
		objFieldID.onkeydown=luFieldID;
		objFieldID.onchange=UpdateFldId;
	}

	if (objLUFieldValue) objLUFieldValue.onclick=luFieldValue;

	if (objFieldValue) {
		objFieldValue.onkeydown=luFieldValue;
		objFieldValue.onchange=UpdateFldValue;
	}

	if (objClassName) objClassName.onchange=UpdateTblName;
	var classobj=document.getElementById("TblName")
	if (classobj) {
		classobj.readOnly=true;
	}
	
	if (objFldId) objFldId.readOnly=true;
	if (objFldValue) objFldValue.readOnly=true;

	if (objTblDisplayName) objTblDisplayName.onchange=TblNameChangeHandler;
	// if simple - remove the complex class name fields
	if (objSimpleDSS && (objSimpleDSS.value==1)) {
		// start class
		if (objTblName) objTblName.style.display="none";
		var objcTblName=document.getElementById('cTblName');
		if (objcTblName) objcTblName.style.display="none";
		// index by
		if (objFldId) objFldId.style.display="none";
		var objcFldId=document.getElementById('cFldId');
		if (objcFldId) objcFldId.style.display="none";
		// index value
		if (objFldValue) objFldValue.style.display="none";
		var objcFldValue=document.getElementById('cFldValue');
		if (objcFldValue) objcFldValue.style.display="none";

	}
	
	var ValLength
}

function TblNameChangeHandler() {
	var str="";
	if (objTblDisplayName){
		str=objTblDisplayName.value
		if (str.length == 0){
			if (objTblName) objTblName.value = "";
		}
	}
	var obj=document.getElementById("FldValue");
	if (obj) obj.value="";
	var obj=document.getElementById("FieldValue");
	if (obj) obj.value="";
}

//function LookUpSQLFieldName1(str) {
//	var lu = str.split("^");
//	if (objFieldID) objFieldID.value = lu[0];
//	if (objFldId) objFldId.value = lu[1];
//}

function UpdateFldId() {
	var str="";
	if (objFieldID){
		str=objFieldID.value
		if (str.length == 0){
			if (objFldId) objFldId.value = "";
		}
	}
}

//function LookUpSQLFieldName2(str) {
//	var lu = str.split("^");
//	if (objFieldValue) objFieldValue.value = lu[0];
//	if (objFldValue) objFldValue.value = lu[1];
//}

function UpdateFldValue() {
	var str="";
	if (objFieldValue){
		str=objFieldValue.value
		if (str.length == 0){
			if (objFldValue) objFldValue.value = "";
		}
	}
}

function LookUpClassName(str) {
	var lu = str.split("^");
	if (objClassName) objClassName.value = lu[1];
	if (objTblName) objTblName.value = lu[0];
	
	if (objFieldID) objFieldID.value = '';
	if (objFieldValue) objFieldValue.value = '';
	if (objFldId) objFldId.value = '';
	if (objFldValue) objFldValue.value = '';
}


function UpdateTblName() {
	var str="";
	if (objClassName){
		str=objClassName.value
		if (str.length == 0){
			if (objTblName) objTblName.value = "";
		}
	}
}

function luFieldID() {
	var TblName='';
	var FieldID='';
	var SimpleDSS='';
	
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (objTblName) TblName=objTblName.value;
		if (objFieldID) FieldID=objFieldID.value;
		if (objSimpleDSS) SimpleDSS=objSimpleDSS.value;
		LookUpFieldName="FieldID";
		var url='websys.dssrule.lookup.csp?classname=' + TblName + '&LookUpFieldName=' + LookUpFieldName + '&sqlfieldname=' + FieldID+ '&SimpleDSS=' + SimpleDSS;
		websys_lu(url,true,'');
		return websys_cancel();
	}
}
	
function luFieldValue() {
	var TblName='';
	var FieldValue='';
	var SimpleDSS='';
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (objTblName) TblName=objTblName.value;
		if (objFieldValue) FieldValue=objFieldValue.value;
		if (objSimpleDSS) SimpleDSS=objSimpleDSS.value;
		LookUpFieldName="FieldValue";
		var url='websys.dssrule.lookup.csp?classname=' + TblName + '&LookUpFieldName=' + LookUpFieldName + '&sqlfieldname=' + FieldValue+ '&SimpleDSS=' + SimpleDSS + '&DSSRuleEdit=Y';
		//var url='websys.dssrule.lookup.csp?classname=' + TblName + '&LookUpFieldName=' + LookUpFieldName + '&sqlfieldname=' + FieldValue;
		websys_lu(url,true,'');
		return websys_cancel();
	}
}

function AddItem(str) {
	var lu = str.split("^");

	if (LookUpFieldName=="FieldID") {
		if (objFieldID) {
			objFieldID.value = lu[0];
		}
		if (objFldId) {
			objFldId.value = lu[1];
		}
	} else if (LookUpFieldName=="FieldValue") {
		if (objFieldValue) {
			objFieldValue.value = lu[0];
		}
		if (objFldValue) {
			objFldValue.value = lu[1];
		}
	}
}

function ClassDisplayNameLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("TblName");
	if (obj) {
		if (obj.value!=lu[1]) {
			var obj2=document.getElementById("FldValue");
			if (obj2) obj2.value="";
			var obj2=document.getElementById("FieldValue");
			if (obj2) obj2.value="";
		}
		obj.value = lu[1];
	}
	obj=document.getElementById("TblDisplayName")
	if (obj) obj.value = lu[0]

}

document.body.onload=BodyLoadHandler;
