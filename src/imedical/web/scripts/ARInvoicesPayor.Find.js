// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objPayor = document.getElementById("Payor");
var objHiddenPayor = document.getElementById("HiddenPayor");
var objBIN = document.getElementById("RecNumber");

var winOpener=null;


function BodyLoadHandler() {

	if (this.window.opener) winOpener = this.window.opener;

	if (winOpener) {

		var objPayorMain = winOpener.document.getElementById("Payor");
		var objBINMain   = winOpener.document.getElementById("BatchInvoiceNumber");

		if (objPayorMain && objPayorMain.disabled && objPayor) {
			objPayor.value=objPayorMain.value;
			objHiddenPayor.value=objPayorMain.value;
			objPayor.disabled=true;
		}

		if (objBINMain && objBINMain.value!="" && objBIN) objBIN.value=objBINMain.value;
	}
}

document.body.onload=BodyLoadHandler;

