// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// KK 4/Sep/2002 Log 28131 - Selecting multiple values for coding status and validation status.

function BodyLoadHandler(){
	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick=FindClickHandler;
	// SA 17.4.03 - log 35068: Click handler not called on Shortcut event.
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

function SetSelectedCodingStatus() {
	var arrItems = new Array();
	var codstatus="";
	var lst = document.getElementById("CodingStatus");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				codstatus = codstatus + lst.options[j].value + "|"
			}
		}
		codstatus=codstatus.substring(0,(codstatus.length-1));
		//alert("codstatus - " + codstatus);
		var objSelCS = document.getElementById("SelCodingStatus");
		if (objSelCS) objSelCS.value=codstatus;
	}
}

function SetSelectedValStatus() {
	var arrItems = new Array();
	var valstatus="";
	var lst = document.getElementById("ValStatus");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				valstatus = valstatus + lst.options[j].value + "|"
			}
		}
		valstatus=valstatus.substring(0,(valstatus.length-1));
		//alert("valstatus - " + valstatus);
		var objSel = document.getElementById("SelValStatus");
		if (objSel) objSel.value=valstatus;
	}
}


function FindClickHandler(){
	SetSelectedCodingStatus();
	SetSelectedValStatus();
	return find1_click();
}

document.body.onload=BodyLoadHandler;