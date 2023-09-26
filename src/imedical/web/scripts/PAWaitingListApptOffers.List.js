// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tPAWaitingListApptOffers_List");

function DocumentLoadHandler() {
	var obj=document.getElementById("New")
	if (obj) obj.onclick=NewClickHandler
	for (var i=1;i<tbl.rows.length;i++) {
		var dobj=document.getElementById("Deletez"+i)
		if (dobj) dobj.onclick=DeleteClickHandler
		var obj=document.getElementById("APTOFDatez"+i)
		if (obj) obj.onclick=EditClickHandler
	}
}

function DeleteClickHandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	//Log 62649 PeterC 05/03/06
	if(row!="") {
		var aobj=document.getElementById("APTOFApptz"+row)
		if((aobj)&&(aobj.value!="")) {
			alert(t['APPT_DEL']);
			return false;
		}
		else {
			if (!confirm(t["deleteoffer"])) return false;
		}
	}
}

function EditClickHandler(e) {
	var WaitingListID=document.getElementById("WaitingListID").value
	var obj=websys_getSrcElement(e);
	var rowid=obj.id; var rowAry=rowid.split("z");
	var editdoc=top.frames["PAWLAOffEdit"]
	if (editdoc) {
		var ID=document.getElementById("IDz"+rowAry[1]).value
		editdoc.location="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListApptOffers.Edit&PARREF="+WaitingListID+"&ID="+ID
	}
}

function NewClickHandler(e) {
	var WaitingListID=document.getElementById("WaitingListID").value
	var editdoc=top.frames["PAWLAOffEdit"]
	if (editdoc) {
		editdoc.location="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListApptOffers.Edit&PARREF="+WaitingListID+"&ID="
	}
}

document.body.onload=DocumentLoadHandler;