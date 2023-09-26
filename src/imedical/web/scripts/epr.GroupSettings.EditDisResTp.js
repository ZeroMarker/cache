// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.fepr_GroupSettings_EditDisResTp;
var f2=window.opener.document.fepr_GroupSettings_Edit;

function TransferToList2(obj,val) {
	var found=0
	var ary=val.split("^");
	var arytxt=new Array(ary[0]);
	var aryval=new Array(ary[2]);
	for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[2]) found=1;}
	if (found==0) AddItemToList(obj,arytxt,aryval);
}

function docLoadHandler() {
	var lu=f.DisplayResultTypeLookUp;
	var obj=f.DisplayResultTypeSelect;
	callAddItemToList(obj,f.DisplayResultTypeDesc.value,f.DisplayResultTypeID.value,lu,",","|");
	//websys_reSizeT();
}

function DisplayResultTypeLookUp(val) {
	var obj=f.DisplayResultTypeSelect;
	f.DisplayResultTypeLookUp.value="";
	TransferToList2(obj,val)
}

function DeleteSelectedClickHandler(e) {
	var obj=f.DisplayResultTypeSelect;
	ClearSelectedList(obj);
	return false;
}

function UpdateClickHandler(e) {
	var obj=f.DisplayResultTypeSelect;
	ary=returnValues(obj);
	f.DisplayResultTypeID.value=ary.join(",");
	f2.DisplayResultTypes.value=ary.join(",");
	return update1_click();
    
}

window.onload=docLoadHandler;
document.getElementById('update1').onclick = UpdateClickHandler;
document.getElementById('DeleteSelected').onclick = DeleteSelectedClickHandler;

