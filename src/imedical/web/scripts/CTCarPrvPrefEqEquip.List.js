// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tCTCarPrvPrefEqEquip_List");

function DocumentLoadHandler() {
	var obj=document.getElementById("DeleteAll")
	if (obj) obj.onclick=DeleteAllClickHandler;
	var parref=document.getElementById("OPPrefID")
	if ((parref)&&(parref.value=="")) {
		var addequip=document.getElementById("AddEquip")
		if (addequip) {
			addequip.disabled=true;
			addequip.onclick=LinkDisabled;
		}
	}
	if (document.getElementById("ReadOnly").value==1) ReadOnly();
}

function ReadOnly() {
	DisableField("AddEquip");
	DisableField("DeleteAll");
	for (var i=1;i<tbl.rows.length;i++) {
		DisableField("EquipDescz"+i);
		DisableField("DeleteEquipz"+i);
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


document.body.onload=DocumentLoadHandler;