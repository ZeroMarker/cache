// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 16.03.06 50671


var f=document.fepr_GroupSettings_EditAuditTab;
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
	var fcs=document.getElementById("AuditTabLookup");
	var obj=document.getElementById("AuditTabSelect");
	callAddItemToList(obj,f.AuditTabDesc.value,f.AuditTabID.value,fcs,"^","^");
    
    var obj=document.getElementById('update1');
    if (obj) obj.onclick = UpdateClickHandler;
    var obj=document.getElementById('DeleteSelected');
    if (obj) obj.onclick = DeleteSelectedClickHandler;
}

function AuditTabLookup(val) {
	var obj=document.getElementById("AuditTabSelect");
    var obj2=document.getElementById("AuditTabLookup");
	if (obj2) obj2.value="";
	TransferToList2(obj,val);
}

function DeleteSelectedClickHandler(e) {
	var obj=document.getElementById("AuditTabSelect");
	ClearSelectedList(obj);
	return false;
}

function UpdateClickHandler(e) {
	var obj=document.getElementById("AuditTabSelect");
    var objid=document.getElementById("AuditTabID");
	ary=returnValues(obj);
	if (objid) objid.value=ary.join("^");
	f2.AuditTables.value=ary.join("^");

	return update1_click();
}

document.body.onload=docLoadHandler;


