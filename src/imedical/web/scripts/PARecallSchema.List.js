// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var obj = document.getElementById("Find");
	if (obj) {
		obj.onclick=FindOnClick;
	}
}

function FindOnClick() {

	var objID=document.getElementById("SchemaTypeID");
	var obj=document.getElementById("SchemaType");
	if (obj && (obj.value=="")) {
		objID.value="";
	}
	return Find_click();
}

function LookUpSchemaType(val) {
	var txt = val.split("^");

	var obj=document.getElementById("SchemaTypeID");
	if (obj) {
		obj.value=txt[1];
	}
}

function LookUpHosp(val) {
	var txt = val.split("^");

	var obj=document.getElementById("HospitalID");
	if (obj) {
		obj.value=txt[1];
	}
}

function LookUpLoc(val) {
	var txt = val.split("^");
	var obj=document.getElementById("Location");
	if (obj) {
		obj.value=txt[0];
	}
	var obj=document.getElementById("LocationIDs");
	if (obj) {
		obj.value=txt[0];
	}
}

document.body.onload = BodyLoadHandler;

