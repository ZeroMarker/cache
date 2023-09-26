// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var lst=document.getElementById("StaffList")

function DocumentLoadHandler() {
	var obj=document.getElementById("AddToList")
	if (obj) obj.onclick=AddStaffToList;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=RemoveListItems;
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=UpdateClickHandler;

	//RC If an Id is found, then it's 'edit mode' and all they should be able to change is quantity.
	//RC only able to edit CP Type, not CP, as it's a single person.
	var id=document.getElementById("OpPrefEqID")
	if (id.value!="") EditMode();
}

function EditMode() {
	var obj=document.getElementById("AddToList")
	if (obj) { obj.disabled=true; obj.onclick=""; }
	var obj=document.getElementById("Delete")
	if (obj) { obj.disabled=true; obj.onclick=""; }
	var obj=document.getElementById("CTPCPDesc")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2116iCTPCPDesc")
	if (obj) obj.disabled=true;
	var obj=document.getElementById("CTCPTDesc")
	if (obj) { obj.disabled=true; obj.className="disabledField" }
	var obj=document.getElementById("ld2116iCTCPTDesc")
	if (obj) obj.disabled=true;
	if (lst) { lst.disabled=true; lst.className="disabledField"}
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=EditUpdateClickHandler;
}

function CarPrvLookUpSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("CTPCPDesc")
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("EQCTPCPDR")
	if (obj) obj.value=adata[1];

	var obj=document.getElementById("EQStaffQty")
	if (obj) {
		obj.disabled=true;
		obj.className="disabledField"
		obj.value=1
	}
	var obj=document.getElementById("CTCPTDesc")
	if (obj) {
		obj.disabled=true;
		obj.className="disabledField"
	}
}

function CarPrvTypLookUpSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("CTCPTDesc")
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("EQCareProvType")
	if (obj) obj.value=adata[1];

	var obj=document.getElementById("EQStaffQty")
	if (obj) {
		obj.disabled=false;
		obj.className=""
		obj.value=""
	}
	var obj=document.getElementById("CTPCPDesc")
	if (obj) {
		obj.disabled=true;
		obj.className="disabledField"
	}
}

function AddStaffToList() {
	var cpDesc=document.getElementById("CTPCPDesc")
	var cptDesc=document.getElementById("CTCPTDesc")
	var cpID=document.getElementById("EQCTPCPDR")
	var cptID=document.getElementById("EQCareProvType")
	var Qty=document.getElementById("EQStaffQty")

	if ((cpDesc)&&(cpDesc.className!="disabledField")) {
		if (cpDesc.className=="clsInvalid") return false;
		for (i=0; i<lst.options.length; i++) {
			if (cpID.value==lst.options[i].value) {
				alert(t["CarPrvExists"]);
				return false;
			}
		}
		var desc="1: "+cpDesc.value
		var code=cpID.value+":CP"
		lst.options[lst.options.length] = new Option(desc,code);
	}
	if (((cptDesc)&&(cptDesc.className!="disabledField"))&&((Qty)&&(Qty.className!="disabledField"))) {
		if ((cptDesc.className=="clsInvalid")||(Qty.className=="clsInvalid")) return false;
		if (Qty.value=="") Qty.value=1;
		for (i=0; i<lst.options.length; i++) {
			if (cptID.value==lst.options[i].value) {
				alert(t["CarPrvTypExists"]);
				return false;
			}
		}
		var desc=Qty.value+": "+cptDesc.value
		var code=cptID.value+":CPT"
		lst.options[lst.options.length] = new Option(desc,code);
	}
	if (cpDesc) {cpDesc.disabled=false; cpDesc.className=""; cpDesc.value=""; cpID.value="";}
	if (cptDesc) {cptDesc.disabled=false; cptDesc.className=""; cptDesc.value=""; cptID.value="";}
	if (Qty) {Qty.disabled=false; Qty.className=""; Qty.value="";}
}

function RemoveListItems() {
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}

	var cpDesc=document.getElementById("CTPCPDesc")
	var cptDesc=document.getElementById("CTCPTDesc")
	var cpID=document.getElementById("EQCTPCPDR")
	var cptID=document.getElementById("EQCareProvType")
	var Qty=document.getElementById("EQStaffQty")
	if (cpDesc) {cpDesc.disabled=false; cpDesc.className=""; cpDesc.value=""; cpID.value="";}
	if (cptDesc) {cptDesc.disabled=false; cptDesc.className=""; cptDesc.value=""; cptID.value="";}
	if (Qty) {Qty.disabled=false; Qty.className=""; Qty.value="";}
}

function UpdateClickHandler() {
	var liststring="";

	for (i=0; i<lst.options.length; i++) {
		var txt=lst.options[i].text.split(": ")
		liststring=liststring+lst.options[i].value+"*"+txt[0]+"^";
	}

	document.getElementById("StaffIDList").value=liststring;
	return Update_click();
}

function EditUpdateClickHandler() {
	var liststring="";
	var cptID=document.getElementById("EQCareProvType")
	var Qty=document.getElementById("EQStaffQty")
	var id=document.getElementById("OpPrefEqID")

	if (Qty.value=="") Qty.value=1;
	liststring=cptID.value+":CPT"+"*"+Qty.value+"*"+id.value+"^";

	document.getElementById("StaffIDList").value=liststring;
	return Update_click();
}

document.body.onload=DocumentLoadHandler;