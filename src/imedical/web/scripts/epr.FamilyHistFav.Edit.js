// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// pjc 16.10.06 60087

function BodyLoadHandler() {
	LoadParams();

	var obj=document.getElementById("RemDiag");
	if (obj) obj.onclick=RemoveItems;

	var obj=document.getElementById("ShiftUp");
	if (obj) obj.onclick=ShiftUp;
	var obj=document.getElementById("ShiftDown");
	if (obj) obj.onclick=ShiftDown;
	var obj=document.getElementById("ShiftLeft");
	if (obj) obj.onclick=ShiftLeft;
	var obj=document.getElementById("ShiftRight");
	if (obj) obj.onclick=ShiftRight;
	var obj=document.getElementById("SaveLvl");
	if ((obj)&&(obj.value=="")) SetSaveAs("U");

	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}

	// only able to select items from one listboxes at a time
	var obj=document.getElementById("DiagList1");
	if (obj) obj.onclick=Diag1ClickHandler;

	var obj=document.getElementById("DiagList2");
	if (obj) obj.onclick=Diag2ClickHandler;
}


function Diag1ClickHandler() {
	var obj=document.getElementById("DiagList2");
	if (obj) selectOptions(obj,"");
}

function Diag2ClickHandler() {
	var obj=document.getElementById("DiagList1");
	if (obj) selectOptions(obj,"");
}

function LoadParams() {
	// load params from websys.preferences into fields
	// diagnosis lists are populated through lookup
	var param=document.getElementById("Params");
	if (param) param=param.value;

	if (param!="") {
		param=param.split(String.fromCharCode(1));
		//alert(param);

		var obj=document.getElementById("ListLabel1");
		if (obj) obj.value=param[0];
		var obj=document.getElementById("ListLabel2");
		if (obj) obj.value=param[1];
		var obj=document.getElementById("DiagCodes1");
		if (obj) obj.value=param[2];
		var obj=document.getElementById("DiagCodes2");
		if (obj) obj.value=param[3];


	}

	var obj=document.getElementById("ObjectType");
	if (obj) {
		if (obj.value=="User.SSUser") SetSaveAs("U");
		if (obj.value=="User.CTLoc") SetSaveAs("L");
		if (obj.value=="User.SSGroup") SetSaveAs("G");
		if (obj.value=="SITE") SetSaveAs("T");
	}
}

function UpdateHandler() {
	SetCodes();

	return update1_click();
}

function SetCodes() {
	// set hidden strings to save in preferences

	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		var DiagCodes="";
		for (var i=0; i<obj.length; i++) {
			//obj.options[i].OrderString=str;
			if (i>0) DiagCodes=DiagCodes+"^";
			DiagCodes=DiagCodes+obj.options[i].value;
		}
		if (lists[j]=="DiagList1") var objdiag=document.getElementById("DiagCodes1");
		if (lists[j]=="DiagList2") var objdiag=document.getElementById("DiagCodes2");
		if (objdiag) objdiag.value=DiagCodes;
	}
}


function SetSaveAs(level) {
	var obj=document.getElementById("SaveLvl");
	if (obj) obj.value=level;
	var obj=document.getElementById("SaveLevel");
	var obj2=document.getElementById("Save"+level);
	if (obj) {
		obj.innerText=t["Save"+level];
		if (obj2) obj.innerText=obj.innerText+" ("+obj2.value+")";
	}
}

function DiagnosisLookup(str) {
	var lu=str.split("^");
	if (lu[2]!="") {
		var obj=document.getElementById("DiagList1");
		if (obj) {
			AddItemSingle(obj,lu[2],lu[0]);
			obj.options[obj.options.length-1].OrderString=lu[3];
		}
		var obj=document.getElementById("Diagnosis");
		if (obj) {
			obj.value="";
			websys_setfocus("Diagnosis");
		}

	}
}

function RemoveItems() {
	var obj=document.getElementById("DiagList1");
	ClearSelectedList(obj);
	var obj=document.getElementById("DiagList2");
	ClearSelectedList(obj);
}

function ShiftUp() {
	var obj=document.getElementById("DiagList1");
	if (obj) UpClick2(obj);
	var obj=document.getElementById("DiagList2");
	if (obj) UpClick2(obj);
}

function ShiftDown() {
	var obj=document.getElementById("DiagList1");
	if (obj) DownClick2(obj);
	var obj=document.getElementById("DiagList2");
	if (obj) DownClick2(obj);
}

function ShiftLeft() {
	var obj1=document.getElementById("DiagList2");
	var obj2=document.getElementById("DiagList1");
	if ((obj1)&&(obj2)) SwapToList2(obj1,obj2,1);
}

function ShiftRight() {
	var obj1=document.getElementById("DiagList1");
	var obj2=document.getElementById("DiagList2");
	if ((obj1)&&(obj2)) SwapToList2(obj1,obj2,1);
}

//copied from websys.ListBoxes.js for modifiecation
function SwapToList2(lstFrom,lstTo,highlightSelected) {
	for (var j=0; j<lstFrom.options.length; j++) {
		var opt = lstFrom.options[j];
		if (opt.selected) {
			AddItemSingle(lstTo,opt.value,opt.text);
		}
	}
	ClearSelectedList(lstFrom);
}

function UpClick2(obj) {
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>0)) Swap2(obj,i,i-1)
	return false;
}

function DownClick2(obj) {
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>=0)&&(i<(len-1))) Swap2(obj,i,i+1);
	return false;
}

function Swap2(lst,a,b) { //Swap position and style of two options
	var opta=lst.options[a];
	var optb=lst.options[b];
	lst.options[a] = new Option(optb.text,optb.value);
	lst.options[b] = new Option(opta.text,opta.value);
	lst.options[a].selected = optb.selected;
	lst.options[b].selected = opta.selected;
}

document.body.onload = BodyLoadHandler;
