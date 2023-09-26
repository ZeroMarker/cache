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
	var obj=document.getElementById("SaveLvl");
	if ((obj)&&(obj.value=="")) SetSaveAs("U");

	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}

}

function LoadParams() {
	// load params from websys.preferences into fields
	// diagnosis lists are populated through lookup
	var param=document.getElementById("Params");
	if (param) param=param.value;

	if (param!="") {
		param=param.split(String.fromCharCode(1));

		var obj=document.getElementById("SocialHistCodes");
		if (obj) obj.value=param[0];

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
	var objList = document.getElementById("SocialHistList");
	var SocHistCodes="";
	for (var i=0; i<objList.length; i++) {
			if (i>0) SocHistCodes=SocHistCodes+"^";
			SocHistCodes=SocHistCodes+objList.options[i].value;
	}
	if (objList) var objsochist=document.getElementById("SocialHistCodes");
	if (objsochist) objsochist.value=SocHistCodes;
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

function SocialHistLookup(str) {
	var lu=str.split("^");
	if (lu[2]!="") {
		var obj=document.getElementById("SocialHistList");
		if (obj) {
			AddItemSingle(obj,lu[2],lu[1]+" - "+lu[0]);
		}
		var obj=document.getElementById("Habit");
		if (obj) {
			obj.value="";
			websys_setfocus("Habit");
		}

	}
}

function RemoveItems() {
	var obj=document.getElementById("SocialHistList");
	ClearSelectedList(obj);
}

function ShiftUp() {
	var obj=document.getElementById("SocialHistList");
	if (obj) UpClick2(obj);
}

function ShiftDown() {
	var obj=document.getElementById("SocialHistList");
	if (obj) DownClick2(obj);
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
