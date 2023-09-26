// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//Log 57858, Bo: 19-07-2006
var tbl=document.getElementById("tRTMasVol_InactivatedVolumesList");
var hiddenTelNo="";
var selFlag=0;
function SelectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj) && (sobj.disabled==false) ) {
				sobj.checked=true;
			}

		}
	}
	return false;
}

function DeselectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj) && (sobj.disabled==false) ) {
				sobj.checked=false;
			}

		}
	}
	return false;
}

function RefreshAfterNewVolume(){
	window.treload("websys.reload.csp");
}

function docLoaded() {
	var RFobj=document.getElementById("ReloadFlag");
	if((RFobj)&&(RFobj.value=="Y"))	RefreshParent();

	SetFocus();

	var lenobj=obj=parent.frames[0].document.getElementById("TblLength");
	var pcurrMRType="";

	/*
	if (lenobj) {
		var pcurrMRN="";
		var pcurrMRType="";
		//var currBatchID="";
		var pcurrVolNo="";   
		var pcurrinactivateFrom="";
		var pcurrinactivateTo="";
		var pcurrInactivateReason="";

		var mrnobj=parent.frames[0].document.getElementById("MRN");
		if (mrnobj) pcurrMRN=mrnobj.value;

		var mrtypeobj=parent.frames[0].document.getElementById("MRType");
		if (mrtypeobj) pcurrMRType=mrtypeobj.value;

		var volnoobj=parent.frames[0].document.getElementById("VolumeNumber");
		if (volnoobj) pcurrVolNo=volnoobj.value;

		var infromobj=parent.frames[0].document.getElementById("InactivatedFrom");
		if (infromobj) pcurrinactivateFrom=infromobj.value;

		var intoobj=parent.frames[0].document.getElementById("InactivatedTo");
		if (intoobj) pcurrinactivateTo=intoobj.value;

		var inreasonobj=parent.frames[0].document.getElementById("InactivateReason");
		if (inreasonobj) pcurrInactivateReason=inreasonobj.value;		
	}
	*/
	
	EnableFindLink();
}

function EnableFindLink(){

	var fr=parent.frames[0];
	if ((fr)&&(fr.name=="FindInactivatedVolumes")) {
		var obj=window.parent.frames[0].document.getElementById("find1");
		if (obj) {
			obj.onclick=window.parent.frames[0].FindClick_Handler;
			obj.disabled=false;
		}
	}
	return true;
}

function SetFocus() {
	var urobj=parent.frames[0].document.getElementById("MRN");
	if (urobj) {
		urobj.select();
		urobj.focus();
	}

}

var sobj=document.getElementById("SelectAll");
if (sobj) sobj.onclick=SelectAll;

function ReactivateClickHandler() {
    var CONTEXT=session['CONTEXT'];
    var PatientIDs="";
	var RTMasVolIDs="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj)&&(sobj.checked)) {
				var VIDObj=document.getElementById("IDz"+i);
				RTMasVolIDs=RTMasVolIDs+VIDObj.value+"^";
			}
		}
	}
	if (RTMasVolIDs=="") {
		alert(t['NoRowsSelected']);
		return false;
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTMasVol.ReactivateVolumes&RTMasVolIDs="+RTMasVolIDs;
	websys_lu(url,false,"");
	
}

document.body.onload=docLoaded;

var sobj=document.getElementById("SelectAll");
if (sobj) sobj.onclick=SelectAll;

var dsobj=document.getElementById("DeselectAll");
if (dsobj) dsobj.onclick=DeselectAll;