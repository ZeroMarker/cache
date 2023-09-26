// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function coderHandler(e) {

	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");	
	var PatientID=document.getElementById("PatientIDz"+rowAry[1]).value;
	var EpisodeID=document.getElementById("EpisodeIDz"+rowAry[1]).value;
	var objCoderFlag = top.frames["TRAK_hidden"].document.getElementById("IsCoderRunning");
	
	if (objCoderFlag && objCoderFlag.value == "1")
	{
		alert("Cannot activate a new Coding Session.\nYou must close existing session to do so\n");
		return false;
	}

	//AJI log 40750 - 20.11.03
	var CONTEXT=session['CONTEXT'];
	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var TWKFL="";
	var TWKFLI="";
	if (objTWKFL)   TWKFL=objTWKFL.value;
	if (objTWKFLI)  TWKFLI=objTWKFLI.value;
	
	var link = "paadm.drgcoding.coder3m.csp?PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&LoadedFromList=Y";
	link += "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

	websys_createWindow(link,"TRAK_hidden");

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tPAAdm_ListCoding");

	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Codingz"+i)
		if (obj) obj.onclick = coderHandler;
		//var objSMR=document.getElementById("ValidateSMRz"+i)
		//if (objSMR) objSMR.onclick = SetSMRFlag;		
	}
}

function BodyLoadHandler() {
	RemoveUnwantedLinks();

	var tbl=document.getElementById("tPAAdm_ListCoding");
	var f=document.getElementById("fPAAdm_ListCoding");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			// RQG 03.04.03 L32764: Disable Link Image
			var objAdm=document.getElementById('AdmTypez'+i);
			if (objAdm) DisableLink('AdmTypez'+i);
			var objDec=document.getElementById('Deceasedz'+i);
			if (objDec) DisableLink('Deceasedz'+i);
		}
	}

	assignClickHandler();
}

function RemoveUnwantedLinks() {
	var tbl=document.getElementById("tPAAdm_ListCoding");
	var f=document.getElementById("fPAAdm_ListCoding");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('ClinNotesz'+i);
			if (obj) {		
				if (obj.innerHTML=="No") {
					var deletenode=obj.removeNode(false);
				}
			}
		}
	}
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if ((el.disabled)||(el.id=="")) {
		return false;
	}
	return true;
}

function DisableLink(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		//alert("fld="+fld.id);
		fld.value = "";
		fld.disabled = true;
		fld.onclick=LinkDisable
		fld.className = "disabledLink";
	}
}

document.body.onload = BodyLoadHandler;