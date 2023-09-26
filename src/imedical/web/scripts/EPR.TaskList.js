// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//log 56840

function CareProvLookUpHandler(txt) {
	//alert (txt);
	if (txt) {
		var adata=txt.split("^");
		var obj=document.getElementById("CareProviderDR");
		if (obj) obj.value=adata[1];
	}
}

function BodyloadHandler() {
	var CareProviderDR="";
	var TaskStatus="";
	var obj=document.getElementById("CareProviderDR");
	if (obj) CareProviderDR=obj.value;
	var obj=document.getElementById("TaskStatus");
	if (obj) TaskStatus=obj.value;

	// JD - log 63246 - & optimizing performace
	var OverDue=tkMakeServerCall("epr.TaskList","CheckOverdue",CareProviderDR,TaskStatus);
	//var OverdueTasks=document.getElementById("OverdueTasks");
	//alert (OverDue);
	//var OverdueTaskIDs=document.getElementById("OverdueTaskIDs");
	//if (OverdueTaskIDs) OverdueTaskIDs.value=OverDue;
	if (OverdueTasks && OverDue=="1") {
		OverdueTasks.style.fontWeight="bold";
	}
}

function OverdueTaskIDsClickHandler() {
	var CareProviderDR="";
	var obj=document.getElementById("CareProviderDR");
	if (obj) CareProviderDR=obj.value;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=EPR.OverdueTaskList&CareProviderDR="+CareProviderDR;
	window.open(url,"OverdueTaskList","top=50,left=50,width=900,height=500,scrollbars=yes,status=yes");
}

var CareProviderObj=document.getElementById("CareProvider");
if (CareProviderObj) CareProviderObj.onclick=CareProvLookUpHandler;
var OverdueTasksObj=document.getElementById("OverdueTasks");
if (OverdueTasksObj) OverdueTasksObj.onclick=OverdueTaskIDsClickHandler;

window.onload=BodyloadHandler;