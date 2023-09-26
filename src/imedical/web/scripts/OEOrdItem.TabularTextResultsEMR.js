// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
f=document.fOEOrdItem_TabularTextResultsEMR;

function TagResults() {
}

function BodyLoadHandler() {
	var obj=document.getElementById("Restrict");
	if ((obj)&&(obj.value!=0)) {
		var obj=document.getElementById("UpdateAndNext");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}
	}
	var obj=document.getElementById("RESSTCode");
	if ((obj)&&(obj.value!="A")&&(obj.value!="K")) {
		var obj=document.getElementById("UpdateAndNext");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}
	}
	var obj=document.getElementById('Result');
	if (obj) {
		obj.readOnly=true;
		// Log 29496
		// Now re-run first focus, as it may have already been called before we set the result object to read only
		websys_firstfocus();
	}

	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		var obj=document.getElementById('EscalationHistory');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
	}

	var obj=document.getElementById("CanReadItems");
	if ((obj)&&(obj.value!=1)) {
		var obj=document.getElementById("UpdateAndNext");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		obj=document.getElementById("Unread");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var MarkAsReadobj=document.getElementById('MarkAsRead');
		if (MarkAsReadobj) {
			MarkAsReadobj.disabled = true;
		}

	}

	var objRead=document.getElementById('ReadBy');
	if (objRead) {
		objRead.onclick=ReadByHandler;
	}

	UpdateBodyLoadHandler();

}

function ReadByHandler()
{
	var tableRowId=document.getElementById('ID');
	var patientId=document.getElementById('ID');
	var url="websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ListEMRResults.AuditRead";

	if (ResultType=="RTFLAB"){
		url = url + "&table=OE_OrdItem&tablerowid=" + tableRowId.value + "&fieldno=OEORI_DateRead&PatientID=" + patientId.value + "&PatientBanner=1";
		websys_createWindow(url, 'ReadBy', 'top=50,left=80,width=400,height=300,scrollbars=yes,resizable=yes');
	}else{
		url = url + "&table=OE_TextResult&tablerowid=" + tableRowId.value + "&fieldno=TR_DateRead&PatientID=" + patientId.value + "&PatientBanner=1";
		websys_createWindow(url, 'ReadBy', 'top=50,left=80,width=400,height=300,scrollbars=yes,resizable=yes');
	}

	return;
}

// this will be done on the load - we will open our own document
document.body.onload = BodyLoadHandler;


