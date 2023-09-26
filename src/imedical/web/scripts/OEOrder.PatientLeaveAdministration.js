// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function BodyOnLoadHandler() {
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClick;

	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClick;

	return;
}

function UpdateClick(){

	var tbl=document.getElementById("tOEOrder_PatientLeaveAdministration");

	if (tbl) {
		var CopyList="";
		for (var i=1;i<tbl.rows.length;i++) {
			var Selected=document.getElementById("Selectz"+i);
			if (Selected && (Selected.checked==true)) {
				var Hid=document.getElementById("Hiddenz"+i);
				var Loc=document.getElementById("RecLocz"+i);
				if (Hid && Loc) {
					if (Loc.value=="") {
						alert(t['RECLOCREQ']);
						return;
					}
					CopyList+=Hid.value+"^"+Loc.value+"*";
				}
			}
		}
		var CopyOrders=document.getElementById("CopyOrders");
		if (CopyOrders) CopyOrders.value=CopyList;
	}

	return Update_click();
}

function FindClick(){
	var EpisodeID,LeaveDTFrom,LeaveTIFrom,LeaveDTTo,LeaveTITo,PatientID="";
	var DTFobj=document.getElementById("LeaveDTFrom");
	if (DTFobj) LeaveDTFrom=DTFobj.value;
	var DTTobj=document.getElementById("LeaveDTTo");
	if (DTTobj) LeaveDTTo=DTTobj.value;
	var TIFobj=document.getElementById("LeaveTIFrom");
	if (TIFobj) LeaveTIFrom=TIFobj.value;
	var TITobj=document.getElementById("LeaveTITo");
	if (TITobj) LeaveTITo=TITobj.value;
	var Epobj=document.getElementById("EpisodeID");
	if (Epobj) EpisodeID=Epobj.value;
	var Patobj=document.getElementById("PatientID");
	if (Patobj) PatientID=Patobj.value;
	var CPobj=document.getElementById("CTPCPDesc");
	if (CPobj) CTPCPDesc=CPobj.value;
	var COMobj=document.getElementById("Comment");
	if (COMobj) Comment=escape(COMobj.value);

	var url="oeorder.patleaveadm.csp?reload=1&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&LeaveDTFrom="+LeaveDTFrom+"&LeaveDTTo="+LeaveDTTo+"&LeaveTIFrom="+LeaveTIFrom+"&LeaveTITo="+LeaveTITo+"&CTPCPDesc="+CTPCPDesc+"&Comment="+Comment ;

	window.location=url;
	return;
}

document.body.onload=BodyOnLoadHandler;