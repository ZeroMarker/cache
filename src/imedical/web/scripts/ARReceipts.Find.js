// Copyright (c) 2005 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {

	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

function FindClickHandler(evt) {

	var CONTEXT =session['CONTEXT']
	var Cashier ="";
	var Location="";
	var Date    ="";
	var TimeFrom="";
	var TimeTo  ="";

	var objCashier = document.getElementById("Cashier");
	var objLocation = document.getElementById("Location");
	var objDate = document.getElementById("Date");
	var objTimeFrom = document.getElementById("TimeFrom");
	var objTimeTo = document.getElementById("TimeTo");

	if (objCashier) Cashier=objCashier.value;
	if (objLocation) Location=objLocation.value;
	if (objDate) Date=objDate.value
	if (objTimeFrom) TimeFrom=objTimeFrom.value;
	if (objTimeTo) TimeTo=objTimeTo.value;

	var url= "arreceipts.inquiry.csp?Cashier="+Cashier+"&Location="+Location+
	"&Date="+Date+"&TimeFrom="+TimeFrom+"&TimeTo="+TimeTo+"&CONTEXT="+CONTEXT;

	find1_click();

	websys_createWindow(url,"TRAK_main");
}

document.body.onload=BodyLoadHandler;