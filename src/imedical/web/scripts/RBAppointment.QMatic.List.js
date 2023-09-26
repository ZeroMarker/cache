// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tRBAppointment_QMatic_List");

function DocumentLoadHandler() {
	var obj=document.getElementById("New")
	if (obj) obj.onclick=NewClickHandler
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Deletez"+i)
		if (obj) obj.onclick=DeleteClickHandler
		var obj=document.getElementById("QMNumberz"+i)
		if (obj) obj.onclick=EditClickHandler
	}
}

function DeleteClickHandler(e) {
	if (!confirm(t["deleteitem"])) return false;
}

function EditClickHandler(e) {
	var ApptID=document.getElementById("ApptID").value
	var obj=websys_getSrcElement(e);
	var rowid=obj.id; var rowAry=rowid.split("z");
	var editdoc=top.frames["RBApptQMEdit"]
	if (editdoc) {
		var ID=document.getElementById("QMRowIdz"+rowAry[1]).value
		editdoc.location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.QMatic.Edit&PARREF="+ApptID+"&ID="+ID
	}
}

function NewClickHandler(e) {
	var ApptID=document.getElementById("ApptID").value
	var editdoc=top.frames["RBApptQMEdit"]
	if (editdoc) {
		editdoc.location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.QMatic.Edit&PARREF="+ApptID+"&ID="
	}
}

document.body.onload=DocumentLoadHandler;