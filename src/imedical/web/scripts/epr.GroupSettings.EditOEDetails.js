// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.fepr_GroupSettings_EditOEDetails;
var f2=window.opener.document.fepr_GroupSettings_Edit;

function docLoadHandler() {
	fcs=f.OEItemDetailsLookUp;
	var obj=f.OEItemDetailsSelect;
	if (obj) callAddItemToList(obj,f.OEItemDetailsDesc.value,f.OEItemDetailsID.value,fcs);
	obj=f.OEItemSubcatSelect;
	if (obj) callAddItemToList(obj,f.OEItemSubcatDesc.value,f.OEItemSubcatID.value,fcs);
	obj=f.OEItemItemSelect;
	if (obj) callAddItemToListForItemItem(obj,f.OEItemItemDesc.value,f.OEItemItemID.value,fcs);
	obj=f.OESetItemsSelect;
	if (obj) callAddItemToList(obj,f.OESetItemsDesc.value,f.OESetItemsID.value,fcs);
	obj=f.OESetSubcatSelect;
	if (obj) callAddItemToList(obj,f.OESetSubcatDesc.value,f.OESetSubcatID.value,fcs);
	obj=f.OEExecSubcatSelect;
	if (obj) callAddItemToList(obj,f.OEExecSubcatDesc.value,f.OEExecSubcatID.value,fcs);
	obj=f.OEExecItemSelect;
	if (obj) callAddItemToListForItemItem(obj,f.OEExecItemDesc.value,f.OEExecItemID.value,fcs);
	//log 58162 BoC 04-09-2006: add Select for "Show questionnaire for orders of subcategory" and "Show questionnaire for orders of category"
	obj=f.OEQuesCatSelect;
	if (obj) callAddItemToList(obj,f.OEQuesCatDesc.value,f.OEQuesCatID.value,fcs);
	obj=f.OEQuesSubcatSelect;
	if (obj) callAddItemToList(obj,f.OEQuesSubcatDesc.value,f.OEQuesSubcatID.value,fcs);
	//websys_reSizeT();
	//websys_reSize();
}
function callAddItemToListForItemItem(obj,txtstr,valstr,fcs) {
	var arytxt=txtstr.split("||"); 
	var aryval=valstr.split(",");
	var arytxtNew = new Array();
	var aryvalNew = new Array();
	var k=0; var match=0;
	//KM 13-Jul-2002: check for duplicates
	//alert(aryval.length);
	for (j=0;j<aryval.length;j++) {
		match=0;
		for (i=0;i<obj.length;i++) {
			if (obj.options[i].value==aryval[j]) {match=1;break}
		}
		if (match==0) {aryvalNew[k]=aryval[j];arytxtNew[k]=arytxt[j];k++}
	}
	AddItemToList(obj,arytxtNew,aryvalNew);
}
function LookUpOESetItems(val) {
	var obj=f.OESetItemsSelect;
	f.OESetItemsLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOEItemDetails(val) {
	var obj=f.OEItemDetailsSelect;
	f.OEItemDetailsLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOEItemSubCatDetails(val) {
	var obj=f.OEItemSubcatSelect;
	f.OEItemSubcatLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOEExecSubCatDetails(val) {
	var obj=f.OEExecSubcatSelect;
	f.OEExecSubcatLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOESetSubCatDetails(val) {
	var obj=f.OESetSubcatSelect;
	f.OESetSubcatLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOEItemItemDetails(val) {
	var obj=f.OEItemItemSelect;
	f.OEItemItemLookUp.value="";
	TransferToListOrderItem(obj,val)
}
function LookUpOEExecItemDetails(val) {
	var obj=f.OEExecItemSelect;
	f.OEExecItemLookUp.value="";
	TransferToListOrderItem(obj,val)
}

//log 58162 BoC 04-09-2006: add lookup handlers for "Show questionnaire for orders of subcategory" and "Show questionnaire for orders of category"
function LookUpOEQuesCat(val) {
	var obj=f.OEQuesCatSelect;
	f.OEQuesCatLookUp.value="";
	TransferToList(obj,val)
}
function LookUpOEQuesSubcat(val) {
	var obj=f.OEQuesSubcatSelect;
	f.OEQuesSubcatLookUp.value="";
	TransferToList(obj,val)
}

function TransferToListOrderItem(obj,val) {
	var found=0
	ary=val.split("^")
	arytxt=ary[0];
	aryval=ary[1];
	for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[1]) found=1;}
	if (found==0) {
		if (arytxt!="") {
			var lstlen=obj.length;
			obj.options[lstlen] = new Option(arytxt,aryval); 
		}
	}
}
function OEItemDetailsDeleteClickHandler(e) {
	var obj=f.OEItemDetailsSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OESetItemsSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OEItemSubcatSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OEItemItemSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OESetSubcatSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OEExecSubcatSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OEExecItemSelect;
	if (obj) ClearSelectedList(obj);
	//log 58162 BoC 04-09-2006: add delete handlers for "Show questionnaire for orders of subcategory" and "Show questionnaire for orders of category"
	obj=f.OEQuesCatSelect;
	if (obj) ClearSelectedList(obj);
	obj=f.OEQuesSubcatSelect;
	if (obj) ClearSelectedList(obj);
	return false;
}
function UpdateClickHandler(e) {
	//alert(opener.document.forms[0].OEItemDetails);
	var obj=f.OEItemDetailsSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEItemDetailsID.value=ary.join(",");
		f2.OEItemDetailsID.value=ary.join(",");
	}
	var obj=f.OEItemSubcatSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEItemSubcatID.value=ary.join(",");
		f2.OEItemSubcatID.value=ary.join(",");
	}
	var obj=f.OEItemItemSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEItemItemID.value=ary.join(",");
		f2.OEItemItemID.value=ary.join(",");
	}
	var obj = f.OESetItemsSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OESetItemsID.value=ary.join(",");
		f2.OESetItemsID.value=ary.join(",");
	}
	var obj = f.OESetSubcatSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OESetSubcatID.value=ary.join(",");
		f2.OESetSubcatID.value=ary.join(",");
	}
	var obj=f.OEExecSubcatSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEExecSubcatID.value=ary.join(",");
		f2.OEExecSubcatID.value=ary.join(",");
	}
	var obj=f.OEExecItemSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEExecItemID.value=ary.join(",");
		f2.OEExecItemID.value=ary.join(",");
	}
	//log 58162 BoC 04-09-2006: add update handlers for "Show questionnaire for orders of subcategory" and "Show questionnaire for orders of category"
	var obj=f.OEQuesCatSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEQuesCatID.value=ary.join(",");
		f2.OEQuesCatID.value=ary.join(",");
	}
	var obj=f.OEQuesSubcatSelect;
	if (obj) {
		ary=returnValues(obj);
		f.OEQuesSubcatID.value=ary.join(",");
		f2.OEQuesSubcatID.value=ary.join(",");
	}
	//alert(f.OESetSubcatID+"*"+f2.OESetSubcatID);
	return update1_click()
}

window.onload=docLoadHandler;
document.getElementById('update1').onclick = UpdateClickHandler;
document.getElementById('OEItemDetailsDelete').onclick = OEItemDetailsDeleteClickHandler;

