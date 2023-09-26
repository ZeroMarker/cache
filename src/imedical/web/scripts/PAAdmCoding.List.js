// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	// cjb 26/02/2001 - 32693, need to clear EpisodeID after deleting an admission
	EPR_ClearSelectedEpisode();
	RemoveUnwantedLinks();
	RemoveUnwantedLinksVal();
	assignClickHandler();
}

function RemoveUnwantedLinks() {
	var tbl=document.getElementById("tPAAdmCoding_List");
	var f=document.getElementById("fPAAdmCoding_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('ClinNotesz'+i);
			if (obj) {		
				if (obj.innerHTML=="No") {
					var deletenode=obj.removeNode(false);
				}
			}
			//KK 12/Nov/2002 Log 29702
			var objACP=document.getElementById('ACPz'+i);
			if (objACP) {		
				if (objACP.innerHTML=="No") {
					var deletenode=objACP.removeNode(false);
				}
			}
		}
	}
	return false;
}



function RemoveUnwantedLinksVal() {
	var tbl=document.getElementById("tPAAdmCoding_List");
	var f=document.getElementById("fPAAdmCoding_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('ValStatusz'+i);
			if (obj) {		
				if ((obj.innerHTML=="A") || (obj.innerHTML=="V") || (obj.innerHTML=="S")) {
					var deletenode=obj.removeNode(false);
				}
			}
		}
	}
	return false;
}

function MedicodeHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	var PatientID=document.getElementById("PatientIDz"+rowAry[1]).value;
	var EpisodeID=document.getElementById("EpisodeIDz"+rowAry[1]).value;
	var AdmCodingID=document.getElementById("IDz"+rowAry[1]).value;
	var PAAdmCodingID=document.getElementById("IDz"+rowAry[1]).value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmCoding.EditMedicode"+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&AdmCodingID="+AdmCodingID+"&PAAdmCodingID="+PAAdmCodingID  //+"&RegistrationNo="+RegistrationNo
	top.frames["TRAK_hidden"].location=lnk
	return false;
}

function SimpleCodeHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	var AdmCodingID=document.getElementById("IDz"+rowAry[1]).value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmCoding.EditSimplecode"+"&AdmCodingID="+AdmCodingID
	top.frames["TRAK_hidden"].location=lnk
	return false;
}



function assignClickHandler() {
	var tbl=document.getElementById("tPAAdmCoding_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Medicodez"+i)
		if (obj) obj.onclick = MedicodeHandler;

		// RQG 12.12.02 - Log31280: To reload the page from which the validation is called
		var objSMR=document.getElementById("ValidateSMRz"+i)
		if (objSMR) objSMR.onclick = SetSMRFlag;		
		
		// cjb 27/06/2005 51278
		var obj=document.getElementById("SimpleCodez"+i)
		if (obj) obj.onclick = SimpleCodeHandler;
	}
	return;
}

var SMRFlag="";

function SetSMRFlag(e) {
  	SMRFlag="OK";
	return;
}

function UnLoadHandler() {
	if (SMRFlag=="OK") {
		treload();
	}
}

document.body.onload = BodyLoadHandler;
document.body.onunload = UnLoadHandler;