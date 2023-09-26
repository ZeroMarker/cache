// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	//AmiN log 24739  02 May, 2002
	if (self==top) websys_reSizeT();
	//window.moveTo(25,100);
	//window.resizeTo(650,350);
	//window.resizeTo(800,500);
	var tbl=document.getElementById("tRTMVTrans_List");
	//alert(tbl.rows.length);
	if (tbl) {
		if (tbl.rows.length>0) {
			var voldesc="";
			var mrtype="";
			var tvobj=document.getElementById("RTMAVVolDescz1");
			if (tvobj) voldesc=tvobj.value;
			var tmobj=document.getElementById("TYPDescz1");
			if (tmobj) mrtype=tmobj.value;
			var vobj=document.getElementById("Volume");
			if (vobj && voldesc!="") vobj.innerText=voldesc;
			var tobj=document.getElementById("MRType");
			if (tobj && mrtype!="") tobj.innerText=mrtype;
		}
	}
}

function BodyUnloadHandler() {
	//Log 31684
	if (window.event) {
		if (window.event.clientY < 0)
		{
			try {unloadHandler();} catch(e) {}
			//alert("The browser is closing...");
			//window.location.href="websys.closesession.csp";
			if (self == top) {
				var win=window.opener;
				if (win) {
				win.treload('websys.csp');
				}
			}	

		}
	}
}
function xBodyUnloadHandler() {

	var patid="";
	var frm="";
	var openednewwin=0;
	for (i in websys_windows) {
		openednewwin=1; break;
	}
	if (openednewwin) return;
	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;
	var win=window.opener;
	if (win.name=="TRAK_main") frm=window.opener.parent.frames[1].document.forms['fRTMasVol_FindRequestVolume'];

	// LOG 24770 ANA:03.05.02 This section of code commented out so that it just refreshes its parent page;else workflow was not being followed.
	/*if (patid!="" && frm) {  
		var win1=window.opener.parent.frames[0];
				var form=win.document.forms['fRTRequest_Edit']
				var TWKFL=form.document.getElementById("TWKFL").value;
				var TWKFLI=form.document.getElementById("TWKFLI").value;
				var url="rtrequest.edit.csp?PatientID="+patid+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI;

		//var url="rtrequest.edit.csp?PatientID="+patid;
		//alert("url="+url);
		if (win1.parent[1]) win1.parent[1].location.href=url;
	}
	else {*/
	//}
/*
	var patid="";
	var reqid="";
	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;
	var robj=document.getElementById("RequestID");
	if (robj) reqid=robj.value;
	var url="rtvolume.list.csp?PatientID="+patid+"&RequestID="+reqid;
	var win=window.opener;

	if (win) {
		var fr1=win.parent.frames["FindMRRequestList"];
		if (fr1) fr1.location.href=url;
		var fr2=win.parent.frames["FindBulkTracking"];
		if (fr2) {
			//var url="rtvolume.multipatientreqlist.csp?PatientID="+patid+"&RequestID="+reqid;
			fr2.location.href=url;
		}
		//var fr3=win.parent.frames["FindBulkRequestList"];
		//if (fr3) fr3.location.href=url;

	}
*/

	if (self == top) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}

}

//if (self==top) websys_reSizeT();
document.body.onload=BodyLoadHandler;
document.body.onunload=BodyUnloadHandler;