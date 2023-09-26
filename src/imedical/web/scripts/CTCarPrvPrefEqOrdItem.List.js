// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tCTCarPrvPrefEqOrdItem_List");

function DocumentLoadHandler() {
	var obj=document.getElementById("DeleteAll")
	if (obj) obj.onclick=DeleteAllClickHandler;
	var parref=document.getElementById("OPPrefID")
	if ((parref)&&(parref.value=="")) {
		var addorditm=document.getElementById("AddOrdItem")
		if (addorditm) {
			addorditm.disabled=true;
			addorditm.onclick=LinkDisabled;
		}
	}
	if (document.getElementById("ReadOnly").value==1) ReadOnly();
	var obj=document.getElementById("OnlyCurrent")
	if (obj) obj.onclick=CheckForCurrent;
	SetCB();
	GetColrAll();
}

function SetCB() {

	var obj=document.getElementById("OnlyCurrent");
	var obj1=document.getElementById("keeepcurrent");
	if ((obj)&&(obj1)) {
	if (obj1.value=="") obj.checked=true;
	if (obj1.value=="1") obj.checked=false;
	
	}


}

function CheckForCurrent() {
	var obj=document.getElementById("OnlyCurrent")
	var obj1=document.getElementById("keeepcurrent")
	if ((obj)&&(obj.checked)) {	if (obj1) obj1.value="";}
	if ((obj)&&!(obj.checked)) {if (obj1) obj1.value=1;}
	var PARREF=document.getElementById("PARREF").value;
	var arry=PARREF.split("||")
	PARREF=arry[0]+"||"+arry[1];
	var OpPrefID=document.getElementById("PARREF").value;
	var Component="Surg"
	var keeepcurrent=document.getElementById("keeepcurrent").value;
	var url="ssuser.surgicalpreferences.edit.csp?CONTEXT="+session['CONTEXT']+"&PARREF="+PARREF+"&OpPrefID="+OpPrefID+"&keeepcurrent="+keeepcurrent+"&Component="+Component+"&cbcurrent="+keeepcurrent;
	document.fCTCarPrvPrefEqOrdItem_List.target="_parent";
	document.fCTCarPrvPrefEqOrdItem_List.action=url;
	document.fCTCarPrvPrefEqOrdItem_List.submit();
}

	
function ReadOnly() {
	DisableField("AddOrdItem");
	DisableField("DeleteAll");
	for (var i=1;i<tbl.rows.length;i++) {
		DisableField("ARCIMDescz"+i);
		DisableField("ARCOSDescz"+i);
		DisableField("DeleteOrdItemz"+i);
		DisableField("SeqMoveUpz"+i);
		DisableField("SeqMoveDownz"+i);
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (fld.onclick!="") fld.onclick=LinkDisabled;
	}
}

function LinkDisabled() {
	return false;
}

function DeleteAllClickHandler(e) {
	var idstring="";
	for (var i=1;i<tbl.rows.length;i++) {
		var objID=document.getElementById("OpPrefEqIDz"+i)
		if ((objID)&&(objID.value!="")) idstring=idstring+objID.value+"^";
	}
	document.getElementById("idstring").value=idstring
	return DeleteAll_click();
}

function GetColrAll() { 	
	var tbl=document.getElementById("tCTCarPrvPrefeqOrdItem_List");
	var f=document.getElementById("fCTCarPrvPrefeqOrdItem_List");	
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Historyz'+j);
			if ((obj) && (obj.value!="")) {
				
				tbl.rows[j].style.backgroundColor="orange"
				
			}
		}
	}
	return false;
}


document.body.onload=DocumentLoadHandler;