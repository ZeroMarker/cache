// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
}

function ViewStatusLookUp(str) {
 	var lu = str.split("^");
	var aobj;
	aobj=document.getElementById("EVStatus")
	if (aobj) aobj.value = lu[0]
	aobj=document.getElementById("EVStatusDR")
	if (aobj) aobj.value = lu[1]
}
function ViewTypeLookUp(str) {
 	var lu = str.split("^");
	var bobj;
	bobj=document.getElementById("EVType")
	if (bobj) bobj.value = lu[0]
	bobj=document.getElementById("EVTypeDR")
	if (bobj) bobj.value = lu[1]
}
function ViewClientTypeLookUp(str) {
 	var lu = str.split("^");
	var cobj;
	cobj=document.getElementById("EVClientType")
	if (cobj) cobj.value = lu[0]
	cobj=document.getElementById("EVClientTypeDR")
	if (cobj) cobj.value = lu[1]
}
function ViewMethodOfConductLookUp(str) {
 	var lu = str.split("^");
	var dobj;
	dobj=document.getElementById("EVMethodOfConduct")
	if (dobj) dobj.value = lu[0]
	dobj=document.getElementById("EVMethodOfConductDR")
	if (dobj) dobj.value = lu[1]
}
function ViewAdministratorLookUp(str) {
 	var lu = str.split("^");
	var eobj;
	eobj=document.getElementById("EVAdministrator")
	if (eobj) eobj.value = lu[0];
	eobj=document.getElementById("EVAdministratorDR")
	if (eobj) eobj.value = lu[1];
}

document.body.onload=Init;