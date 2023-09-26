// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 30.11.06 61356

function DiagnosisLookup(str) {
	var lu=str.split("^");
	if (lu[1]!="") {
		var objlist=document.getElementById("DiagList");
		if (objlist) AddItemSingle(objlist,lu[1],lu[0]);
	}
	var obj=document.getElementById("Diagnosis");
	if (obj) obj.value="";
}

function DocumentLoadHandler() {
	var obj=document.getElementById("deleteDiag");
	if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById("btnSearch");
	if (obj) obj.onclick=FindClickHandler;
}

function DeleteClickHandler() {
	var objlist=document.getElementById("DiagList");
	if (objlist) ClearSelectedList(objlist);
}

function FindClickHandler() {
	var objlist=document.getElementById("DiagList");
	var objcode=document.getElementById("DiagCodes");
	if ((objlist)&&(objcode)) {
		objcode.value="";
		ARYCODES=returnValues(objlist);
		for (i=0;i<ARYCODES.length;i++) {
			if (objcode.value!="") objcode.value=objcode.value+"^";
			objcode.value=objcode.value+ARYCODES[i];
		}
	}
	
	btnSearch_click();
}

document.body.onload=DocumentLoadHandler;