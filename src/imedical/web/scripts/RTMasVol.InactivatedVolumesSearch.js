// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//Log 57858, Bo: 18-07-2006
if (parent.frames["FindInactivatedVolumes"]) document.forms['fRTMasVol_InactivatedVolumesSearch'].target="InactivatedVolumesList";

var ChrCode="";
var selVolDescFlag="true";
var mrnobj=document.getElementById("MRN");
var mrtypeobj=document.getElementById("MRType");
var volnoobj=document.getElementById("VolumeNumber");
var infromobj=document.getElementById("InactivatedFrom");
var intoobj=document.getElementById("InactivatedTo");
var inreasonobj=document.getElementById("InactivateReason");
var URs="";
var PatReqids="";
var Patbatchids="";
var VolDescIds="";
var TYPIds="";
var MRNs="";
var RTMAVVolDescobj="";

function FindClick_Handler() {	
	var currMRN="";
	var currMRType="";
	//var currBatchID="";
	var currVolNo="";   
	var currinactivateFrom="";
	var currinactivateTo="";
	var currInactivateReason="";

	if (mrnobj) currMRN=mrnobj.value; 
	if (mrtypeobj) currMRType=mrtypeobj.value;
	if (volnoobj) currVolNo=volnoobj.value;
	if (infromobj) currinactivateFrom=infromobj.value;
	if (intoobj) currinactivateTo=intoobj.value;	
	if (inreasonobj) currInactivateReason=inreasonobj.value; 

	var frame=parent.frames["1"];
	if (frame) {
	var tbl=frame.document.getElementById("tRTMasVol_InactivatedVolumesList");
	if (tbl) {
			var f=frame.document.getElementById("f"+tbl.id.substring(1,tbl.id.length)); 
			var lenobj=document.getElementById("TblLength");
			if (lenobj) lenobj.value=tbl.rows.length;
			if (tbl.rows.length>1) {
				var fobj=document.getElementById("TblLength");	
				if (fobj) fobj.value=tbl.rows.length;
			}
		}
		else {
			var fobj=document.getElementById("TblLength");
			if (fobj) fobj.value=1;
		}

	}
	
	find1_click();
	return true;
}

function docLoaded() {
	window.setTimeout("delayedLoad()",200);
}

function delayedLoad() {
	var Fobj=document.getElementById("find1");
	if(Fobj){
		Fobj.disabled=false; 
		Fobj.onclick=FindClick_Handler;
		}
}

document.body.onload=docLoaded; 