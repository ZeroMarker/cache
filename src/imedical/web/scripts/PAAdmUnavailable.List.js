// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAAdmUnavailable_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAAdmUnavailable_List");
	var eSrc;
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	if (objTable) objTable.onclick=UnavailableClickHandler;
}

function updateClickHandler() {
	if (window.name=="paadmunavailable_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	return update1_click();
}

function UnavailableClickHandler(e) {
	var patid="",epid="",parref="",lnk="",TWKFLI="",TWKFL="",id="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
   	var eSrc = websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc)
	}

	if ((parent.frames["paadmunavailable_edit"])&&(eSrc.id!="")) {
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("UNAVDateFromz")==0) {
				eSrc.target = "paadmunavailable_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmUnavailable.Edit&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
			}
			eSrc.href=lnk
		}
	}
}

function NewClickHander() {
	if ((parent)&&(parent.frames)) {
		var EpiID="",PatID="",PARREF="",TWKFL="",TWKFLI="";
		var EpiID=document.getElementById("EpisodeID")
		if (EpiID) EpiID=EpiID.value;
		var PatID=document.getElementById("PatientID")
		if (PatID) PatID=PatID.value;
		var parref=document.getElementById("PARREF");
		if (parref) parref=parref.value;
		var TWKFL=document.getElementById("TWKFL")
		if (TWKFL) TWKFL=TWKFL.value;
		var TWKFLI=document.getElementById("TWKFLI")
		if (TWKFLI) TWKFLI=TWKFLI.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmUnavailable.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;
		websys_createWindow(lnk,"paadmunavailable_edit","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		return false;
	}
}


document.body.onload = DocumentLoadHandler;