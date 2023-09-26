// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function findHandler() {
	var flds=document.forms("fCTZip_CustomFind").elements;
    if (flds['CTZIPDesc']) {P1=websys_escape(flds['CTZIPDesc'].value);} else {P1="";}
	if (flds['CTZIPCode']) {P2=websys_escape(flds['CTZIPCode'].value);} else {P2="";}
	if (flds['CTCITDesc']) {P3=websys_escape(flds['CTCITDesc'].value);} else {P3="";}
	if (flds['PROVDesc']) {P4=websys_escape(flds['PROVDesc'].value);} else {P4="";}
	
	var namevaluepairs="&P1="+P1+"&P2="+P2+"&P3="+P3+"&P4="+P4;
	FindComponent_click(namevaluepairs);  //function defined in websys.lookup.csp
	return false;
}

var obj=document.getElementById("find1");
if (obj) obj.onclick=findHandler;
if (self==top) {
	//websys_reSizeT();
}

function CityandProv(str) {
	var lu = str.split("^");
	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[0];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];
	
}

