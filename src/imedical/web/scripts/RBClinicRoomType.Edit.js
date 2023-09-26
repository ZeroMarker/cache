// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objSingle = document.getElementById("SingleCP");
var objDual = document.getElementById("DualCP");
var objSeq = document.getElementById("SeqCP");

var objClinicType = document.getElementById("ClinicType");

function DocumentLoadHandler(e) {
	if (objSingle) objSingle.onclick = SingleClinicCheck;
	if (objDual) objDual.onclick = DualClinicCheck;
	if (objSeq) objSeq.onclick = SeqClinicCheck;
}

function SingleClinicCheck() {
	if (objSingle.checked) {
		if (objClinicType) objClinicType.value="SI";
		if (objDual) objDual.checked=false;
		if (objSeq) objSeq.checked=false;
	} else {
		if (objClinicType) objClinicType.value="";
	}
}

function DualClinicCheck() {
	if (objDual.checked) {
		if (objClinicType) objClinicType.value="DU";
		if (objSingle) objSingle.checked=false;
		if (objSeq) objSeq.checked=false;
	} else {
		if (objClinicType) objClinicType.value="";
	}
}

function SeqClinicCheck() {
	if (objSeq.checked) {
		if (objClinicType) objClinicType.value="SE";
		if (objDual) objDual.checked=false;
		if (objSingle) objSingle.checked=false;
	} else {
		if (objClinicType) objClinicType.value="";
	}
}
window.onload = DocumentLoadHandler;








