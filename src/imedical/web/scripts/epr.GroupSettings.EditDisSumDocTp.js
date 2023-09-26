// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// Log 42975 - AI - 24-03-2004 : New File for new component. Copiedfrom epr.GroupSettings.EditCarPrvTp.js.

var f=document.fepr_GroupSettings_EditDisSumDocTp;
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
	var fcs=f.DisSumDocTpLookUp
	var obj=f.DisSumDocTpSelect;
	callAddItemToList(obj,f.DisSumDocTpDesc.value,f.DisSumDocTpID.value,fcs,",","|");
	//websys_reSizeT();
}

function DisSumDocTpLookUp(val) {
	var obj=f.DisSumDocTpSelect;
	f.DisSumDocTpLookUp.value="";
	TransferToList2(obj,val)
}

function DeleteSelectedClickHandler(e) {
	var obj=f.DisSumDocTpSelect;
	ClearSelectedList(obj);
	return false;
}

function UpdateClickHandler(e) {
	var obj=f.DisSumDocTpSelect;
	ary=returnValues(obj);
	f.DisSumDocTpID.value=ary.join(",");
	f2.DisSumDocTpID.value=ary.join(",");
	return update1_click();
}

window.onload=docLoadHandler;
document.getElementById('update1').onclick = UpdateClickHandler;
document.getElementById('DeleteSelected').onclick = DeleteSelectedClickHandler;

