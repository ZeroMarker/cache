// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

	// Log 58574 - ML - 21/06/2006 - Delete messages from HL7 Outbound Queue

function DocumentLoadHandler() {
	assignChkHandler();
}

function DeleteClickHandler() {
	var ret=true;

	// check if security group has access to delete message
	var fld=document.getElementById("SecurityGroupCheck");
	if ((fld)&&(fld.value!="1")) {
		alert(t['DenyDelete']);
		ret=false;
	}
	if (ret==false) return false;

	ret=confirm(t['ConfirmDelete']);

	return ret;
}

function assignChkHandler() {
	var tbl=document.getElementById("tSSHL7Queue_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("delete1z"+i);
		if (obj) obj.onclick = DeleteClickHandler;
	}
	return;
}
document.body.onload = DocumentLoadHandler;
