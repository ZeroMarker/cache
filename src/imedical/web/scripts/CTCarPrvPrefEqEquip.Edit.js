// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var lst=document.getElementById("EquipList")

function DocumentLoadHandler() {
	var obj=document.getElementById("AddToList")
	if (obj) obj.onclick=AddEqToList;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=RemoveListItems;
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=UpdateClickHandler;

	//RC If an Id is found, then it's 'edit mode' and all they should be able to change is quantity.
	var id=document.getElementById("OpPrefEqID")
	if (id.value!="") EditMode();
}

function EditMode() {
	var obj=document.getElementById("AddToList")
	if (obj) { obj.disabled=true; obj.onclick=""; }
	var obj=document.getElementById("Delete")
	if (obj) { obj.disabled=true; obj.onclick=""; }
	var obj=document.getElementById("ARCIMDesc")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2114iARCIMDesc")
	if (obj) obj.disabled=true;
	if (lst) { lst.disabled=true; lst.className="disabledField"}
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=EditUpdateClickHandler;
}

function EquipLookupSelect(txt) {
	var adata=txt.split("^");

	var obj=document.getElementById("ARCIMDesc")
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("EQARCIMDR")
	if (obj) obj.value=adata[1];
}

function AddEqToList() {
	var EqDesc=document.getElementById("ARCIMDesc")
	var EqID=document.getElementById("EQARCIMDR")
	var Qty=document.getElementById("EQEquipQty")

	if ((EqDesc)&&(Qty)) {
		if ((EqDesc.className=="clsInvalid")||(Qty.className=="clsInvalid")) return false;
		if (Qty.value=="") Qty.value=1;
		for (i=0; i<lst.options.length; i++) {
			if (EqID.value==lst.options[i].value) {
				alert(t["EquipExists"]);
				return false;
			}
		}
		var desc=Qty.value+": "+EqDesc.value
		var code=EqID.value
		lst.options[lst.options.length] = new Option(desc,code);
		Qty.value=""; EqDesc.value="";
	}
}

function RemoveListItems() {
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}
}

function UpdateClickHandler() {
	var liststring="";

	for (i=0; i<lst.options.length; i++) {
		var txt=lst.options[i].text.split(": ")
		liststring=liststring+lst.options[i].value+"*"+txt[0]+"^";
	}

	document.getElementById("EquipIDList").value=liststring;
	return Update_click();
}

function EditUpdateClickHandler() {
	var liststring="";
	var EqID=document.getElementById("EQARCIMDR")
	var Qty=document.getElementById("EQEquipQty")
	var id=document.getElementById("OpPrefEqID")

	if (Qty.value=="") Qty.value=1;
	liststring=EqID.value+"*"+Qty.value+"*"+id.value+"^";

	document.getElementById("EquipIDList").value=liststring;
	return Update_click();
}

document.body.onload=DocumentLoadHandler;