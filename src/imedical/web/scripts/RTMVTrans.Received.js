// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var updated=0;
function UpdateClickHandler() {
	var vdobj=document.getElementById("VolumeDesc")
	if ((vdobj) && (vdobj.value=="")) {
		alert(t['Volume_Check']);
		update=1;
		
	} else {
		//alert("updating");
		Update_click();
		updated=1;
	}


	var patid="";
	var reqid="";
	var Receive="";

	var patid1="";
	var reqid1="";
	
	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;

	var robj=document.getElementById("Receive");
	if (robj) Receive=robj.value;

	var robj=document.getElementById("RequestID");
	if (robj) reqid=robj.value;

	//bulk
	var pobj1=document.getElementById("PatientIDs");
	if (pobj1) patid1=pobj1.value;
	var robj1=document.getElementById("RequestIDs");
	if (robj1) reqid1=robj1.value;

	var win=window.opener.parent.frames[0];
	//alert(win.name);
	if (win) {
		if (win.name=="FindBulkTracking") {
			var url="rtvolume.multipatientreqlist.csp?PatientIDs="+patid1+"&RequestIDs="+reqid1;
			//alert("bulkurl="+url);
			window.opener.parent.frames["FindBulkTracking"].location.href=url;
		}
		if (win.name=="eprmenu") {
			var url="rtrequest.edit.csp?PatientID="+patid;
			//alert("url="+url);
			if(Receive=="") if (win.parent[1]) win.parent[1].location.href=url;
		}

		if (win.name=="FindMRRequest") {
			//if(patid=="") patid=patids;
			var url="rtvolume.list.csp?PatientID="+patid+"&RequestID="+reqid;
			//alert("url="+url);
			if(Receive=="") window.opener.parent.frames["FindMRRequestList"].location.href=url;
		}

	}
	//alert(win.name);
	//if (window.opener) window.opener.parent.frames["FindMRRequestList"].location.href=url;
	//alert(url);
	//if (window.opener) window.opener.parent.frames["FindBulkTrack"].location.href=url2;

}

function BodyUnloadHandler(e) {
	if ((self == top)&&(updated)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}

//document.body.onunload=BodyUnloadHandler;

var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;

	
