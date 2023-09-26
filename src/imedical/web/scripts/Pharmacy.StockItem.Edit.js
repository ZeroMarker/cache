// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


f=document.fPharmacy_StockItem_Edit;

function DisableClick() {
	return false;
}

function DocumentLoadHandler() {
	var ArcimDR = document.getElementById("ArcimDR");
	var objSubstitute = f.SubstituteItem;
	if (objSubstitute  && ArcimDR) {
		objSubstitute.onclick = SubstituteClick;
		objSubstitute.multiple = false;
		for (var i=0; i<objSubstitute.length; i++) {
			if (objSubstitute.options[i].value == ArcimDR.value) {
				objSubstitute.options[i].selected = true;
			}
		}
	}
	EnableDisableUpdate (CheckOneSelected());
}

function CheckOneSelected() {
	var OneSelected = false;
	var objSubstitute = f.SubstituteItem;
	if (objSubstitute) {
		for (var i=0; i<objSubstitute.length; i++) {
			if (objSubstitute.options[i].selected == true) {
				OneSelected = true;
			}
		}
	}
	return OneSelected;
}

function EnableDisableUpdate(OneSelected) {
	var objUpdate =  document.getElementById("Update");
	if (objUpdate) {
		if (!OneSelected) {
			objUpdate.disabled = true;
			objUpdate.onclick=DisableClick;
		} else {
			objUpdate.onclick=UpdateClickCheck;
		}

	}
}

function UpdateClickCheck(evt) {

	if (!CheckOneSelected()) {
		alert(t['SELECTONE']);
		return false;
	} else {
		var objOrdItem =  document.getElementById("OrdItem");
		var OrdItem = "";
		if (objOrdItem) OrdItem = objOrdItem.value;

		var substID = "";
		var objSubstitute = f.SubstituteItem;
		if (objSubstitute) {
			for (var i=0; i<objSubstitute.length; i++) {
				if (objSubstitute.options[i].selected == true) {
					substID = objSubstitute.options[i].value
				}
			}
		}
		var objNewARCIMDR =  document.getElementById("ItemMastDR");
		if (objNewARCIMDR) {
			objNewARCIMDR.value = substID;
		} 
		return Update_click();
	}
}


function SubstituteClick(evt) {
	var eSrc=websys_getSrcElement(evt);

	EnableDisableUpdate (CheckOneSelected());
	//alert(eSrc.value);
	return true;
}


document.body.onload=DocumentLoadHandler;



