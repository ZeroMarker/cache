// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 21.02.05 48554


var f=document.fepr_GroupSettings_EditDrugInt;
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
	var fcs=document.getElementById("DrugIntLookup");
	var obj=document.getElementById("DrugIntSelect");
	callAddItemToList(obj,f.DrugIntDesc.value,f.DrugIntID.value,fcs,"^","^");
    
    var obj=document.getElementById('update1');
    if (obj) obj.onclick = UpdateClickHandler;
    var obj=document.getElementById('DeleteSelected');
    if (obj) obj.onclick = DeleteSelectedClickHandler;
}

function DrugIntLookup(val) {
	var obj=document.getElementById("DrugIntSelect");
    var obj2=document.getElementById("DrugIntLookup");
	if (obj2) obj2.value="";
	TransferToList2(obj,val);
}

function DeleteSelectedClickHandler(e) {
	var obj=document.getElementById("DrugIntSelect");
	ClearSelectedList(obj);
	return false;
}

function UpdateClickHandler(e) {
	var obj=document.getElementById("DrugIntSelect");
    var objid=document.getElementById("DrugIntID");
	ary=returnValues(obj);
	if (objid) objid.value=ary.join("^");
	f2.DrugIntSeverity.value=ary.join("^");

	return update1_click();
}

document.body.onload=docLoadHandler;


