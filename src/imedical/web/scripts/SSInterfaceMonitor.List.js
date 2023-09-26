// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	// Log 46439 - AI - 22-10-2004 : Alert New Rejection and New Error messages if applicable.
	var objrej=document.getElementById("rejmsg");
	if ((objrej)&&(objrej.value!="")) {
		var rejitem=objrej.value.split("^");
		var rejmsg="";
		for (i=0; i<rejitem.length; i++) {
			rejmsg=rejmsg+"\n"+rejitem[i];
		}
		rejmsg=t['NewRejections']+rejmsg;
		alert(rejmsg);
	}
	var objerr=document.getElementById("errmsg");
	if ((objerr)&&(objerr.value!="")) {
		var erritem=objerr.value.split("^");
		var errmsg="";
		for (i=0; i<erritem.length; i++) {
			errmsg=errmsg+"\n"+erritem[i];
		}
		errmsg=t['NewErrors']+errmsg;
		alert(errmsg);
	}
	// end Log 46439

	// Log 45046 - AI - 17-09-2004 : Set up to refresh the Interface Workbench - stored vs Security Group.
	var IWRefreshTime=0;
	var obj=document.getElementById("IWRefreshTime");
	if (obj) IWRefreshTime=obj.value;
	if (IWRefreshTime!=0) {
		self.setTimeout("window.location.reload(true)",IWRefreshTime);
	}
	// end Log 45046

	assignChkHandler();
}

function DeleteClickHandler() {
	var ret=true;
	// "deletez" plus the row id (starting from 1).
	var activeid=document.activeElement.id;
	//var len=activeid.length-1;

	// Log 42529 - AI - 30-03-2004 : Add a check - if Interface is running (Active), do not delete (causes problems with locks).
	var fld=document.getElementById("MONActivez"+activeid.substr(8,activeid.length-8));
	if ((fld)&&(fld.value=="Y")) {
		alert(t['DeleteActive']);
		ret=false;
	}
	if (ret==false) return false;
	// end Log 42529

	ret=confirm(t['ConfirmDelete']);

	// Log 42529 - AI - 03-03-2004 : Add a second message if this is a HL7 Interface being deleted.
	// Log 46777 - AI - 04-11-2004 : No longer using INTHL7DR - using INTDataType="H" to notify HL7 Interfaces instead.
	if (ret==true) {
		fld=document.getElementById("INTDataTypez"+activeid.substr(8,activeid.length-8));
		if ((fld)&&(fld.value=="H")) {
			ret=confirm(t['HL7Confirm']);
		}
	}
	// end Logs 42529 and 46777

	return ret;
}

function assignChkHandler() {
	var tbl=document.getElementById("tSSInterfaceMonitor_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("delete1z"+i);
		if (obj) obj.onclick = DeleteClickHandler;
	}
	return;
}

document.body.onload = DocumentLoadHandler;
