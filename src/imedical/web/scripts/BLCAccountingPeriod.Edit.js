// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objStatus = document.getElementById("Status");
var newStatus="";

function BodyLoadHandler(evt) {

	var objDel = document.getElementById("delete1");
	if (objDel) objDel.onclick=DeleteHandler;

	var objUpd = document.getElementById("update1");
	if (objUpd) objUpd.onclick=UpdateHandler;
}

function DeleteHandler(evt) {

	if (objStatus && objStatus.value== "O")
		return confirm(t["DEL_OPEN_CONFIRM"]);
	else
		return confirm(t["DEL_CONFIRM"]);
}

function UpdateHandler(evt) {
	if (objStatus && objStatus.value == "O" && newStatus == "C") {
		if (confirm(t["UPDATE_CONFIRM"]))
			update1_click();
	}
	else {
		update1_click();
	}
}

function StatusLookupSelect(str) {
	var lu=str.split("^");
	newStatus = lu[1];
}

document.body.onload=BodyLoadHandler;

