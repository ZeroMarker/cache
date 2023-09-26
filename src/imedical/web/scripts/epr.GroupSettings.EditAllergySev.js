// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 21.02.05 48554


var f=document.fepr_GroupSettings_EditAllergySev;
var f2=window.opener.document.fepr_GroupSettings_Edit;

function TransferToList2(obj,val) {
	var found=0
	var ary=val.split("^");
	var arytxt=new Array(ary[0]);
	var aryval=new Array(ary[1]);
	for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[1]) found=1;}
	if (found==0) AddItemToList(obj,arytxt,aryval);
}

function docLoadHandler() {
	var fcs=document.getElementById("AllergyLookup");
	var obj=document.getElementById("AllergySelect");
	callAddItemToList(obj,f.AllergyDesc.value,f.AllergyID.value,fcs,"^","^");
    
    var obj=document.getElementById('update1');
    if (obj) obj.onclick = UpdateClickHandler;
    var obj=document.getElementById('DeleteSelected');
    if (obj) obj.onclick = DeleteSelectedClickHandler;
}

function AllergyLookUp(val) {
	var obj=document.getElementById("AllergySelect");
    var obj2=document.getElementById("AllergyLookup");
	if (obj2) obj2.value="";
	TransferToList2(obj,val);
}

function DeleteSelectedClickHandler(e) {
	var obj=document.getElementById("AllergySelect");
	ClearSelectedList(obj);
	return false;
}

function UpdateClickHandler(e) {
	var obj=document.getElementById("AllergySelect");
    var objid=document.getElementById("AllergyID");
	ary=returnValues(obj);
	if (objid) objid.value=ary.join("^");
	f2.AllergySeverity.value=ary.join("^");

	return update1_click();
}

document.body.onload=docLoadHandler;


