// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.fepr_GroupSettings_EditPhamacyQ;
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
	var fcs=f.PharmQLookUp
	var obj=f.PharmQSelect;
	callAddItemToList(obj,f.PharmQDesc.value,f.PharmQID.value,fcs,",","|");
	//websys_reSizeT();
}
function PharmQLookUp(val) {
	var obj=f.PharmQSelect;
	f.PharmQLookUp.value="";
	TransferToList2(obj,val)
}
function DeleteSelectedClickHandler(e) {
	var obj=f.PharmQSelect;
	ClearSelectedList(obj);
	return false;
}
function UpdateClickHandler(e) {
	var obj=f.PharmQSelect;
	ary=returnValues(obj);
	f.PharmQID.value=ary.join(",");
	f2.PharmQID.value=ary.join(",");
	return update1_click();
}

window.onload=docLoadHandler;
document.getElementById('update1').onclick = UpdateClickHandler;
document.getElementById('DeleteSelected').onclick = DeleteSelectedClickHandler;

