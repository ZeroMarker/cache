// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	//alert("in RTMasVolAdm.List ");
	rf=1;
	if (self==top) websys_reSizeT();
	//if ((actObj)&&(actObj.value!="Y")&&(MASObj))  MASObj.disabled=true;
}

var rf=1;
var actObj=document.getElementById("ActivateAllowed");
var MASObj=document.getElementById("MarkAsInactive");
if (MASObj) MASObj.onclick=setReloadflag;

var NewObj=document.getElementById("New");
if (NewObj) NewObj.onclick=ResetReloadflag;


function setReloadflag(e) {
	//if ((actObj)&&(actObj.value=="Y")){
		rf=1;
		var url=MASObj.href;
		//AmiN log 24739  02 May, 2002
		// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
		//websys_createWindow(url,"rtmvtrans_mergevolume","height=250,width=500,left=250,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		//websys_createWindow(url,"rtmvtrans_mergevolume","height=190,width=300,left=250,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		websys_createWindow(url,"rtmvtrans_mergevolume","height=300,width=450,left=250,top=150,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	//}
	return false;
}
function ResetReloadflag(e) {
	rf=0;
	var url=NewObj.href;
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"PAAdm_List","height=200,width=500,top=200,left=250,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}


function BodyUnloadHandler(e) {
	var patid="";
	var reqid="";
	var epid="";

	var patid1="";
	var reqid1="";
	var voldesc1="";
	var Page="";

	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;
	var robj=document.getElementById("RequestID");
	if (robj) reqid=robj.value;
	var epobj=document.getElementById("EpisodeID");
	if (epobj) epid=epobj.value;

	var pfobj=document.getElementById("PageFrom");
	if (pfobj) Page=pfobj.value;


	//bulk
	var pobj1=document.getElementById("PatientIDs");
	if (pobj1) patid1=pobj1.value;
	var robj1=document.getElementById("RequestIDs");
	if (robj1) reqid1=robj1.value;
	var vobj1=document.getElementById("RTMAVVolDesc");
	if (vobj1) voldesc1=vobj1.value;
	if (rf) {
		var win=window.opener.parent.frames[0];
		if (win) {
			if ((win.name=="FindBulkTrack")||(win.name=="FindBulkRequest")||(win.name=="FindMRRequest")) {
				RefreshPage();
			}
			if (win.name=="eprmenu") {
				var frm=window.opener.parent.frames[1].document.forms['fRTMasVol_FindRequestVolume'];
				if (patid1=="" && (!frm)) {
					RefreshPage();
				}
				else {
					RefreshPage();
				}
				if (Page=="PostDischarge") {
					var volumeno="";
					var vobj8=document.getElementById("VolumeNo");
					if (vobj8) volumeno=vobj8.value;
					var status="";
					var sobj8=document.getElementById("Status");
					if (sobj8) status=sobj8.value;
					var url="rtpostdischarge.edit.csp?PatientID="+patid+"&EpisodeID="+epid+"&VolumeNo="+volumeno+"&Status="+status;
					if (win.parent[1]) win.parent[1].location.href=url;
				}

			}
		} else if (window.opener) {
			var url="rtrequest.edit.csp?PatientID="+patid;
			var par_path=window.opener.location;
			var arrPath=par_path.pathname.split("/");
			if (arrPath[arrPath.length-1]=="rtrequest.edit.csp") {
				if (window.opener) window.opener.location.href=url;
			} else {
				RefreshPage();
			}
		}

	}
}

function RefreshPage() {

	if (self == top) {
		var win=window.opener;
		//alert(win.name)
		if (win) win.treload('websys.csp');
	}
}

document.body.onload=BodyLoadHandler;
document.body.onunload=BodyUnloadHandler;
