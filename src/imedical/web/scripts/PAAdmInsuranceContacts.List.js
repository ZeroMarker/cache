// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAAdmInsuranceContacts_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAAdmInsuranceContacts_List");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	
	if (updateObj) updateObj.onclick=updateClickHandler;

	if (objTable) objTable.onclick=ContactClickHandler;
	
}

function updateClickHandler() {
	if (window.name=="InsContact_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	return update1_click();
	
}

function ContactClickHandler(e) {
	
	
	var patid=epid=parref=contactid=lnk=TWKFLI=TWKFL=id="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var contactid=document.getElementById("CONTACT_RowId");
 	if (contactid) contactid=contactid.value
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
	var CONTEXT=document.getElementById("CONTEXT")
	if (CONTEXT) CONTEXT=CONTEXT.value;
	var eSrc = websys_getSrcElement(e);
	
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc)
	}
	
	if ((parent.frames["InsContact_edit"])&&(eSrc.id!="")) {

		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("PCTDescz")==0) {
				eSrc.target = "InsContact_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmInsuranceContacts.Edit&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
			}
			
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				var currentlink=eSrc.href.split("?"); 
				var lnk="paadminsurancecontactsframe.csp?"+currentlink[1];
				var lnk="";
			}
			if (lnk!="") eSrc.href=lnk
		}
	}
}
function NewClickHander() {

	if ((parent)&&(parent.frames)&&(parent.frames["InsContact_edit"])) {
	
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmInsuranceContacts.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT
	websys_createWindow(lnk,"InsContact_edit",""); 
	return false;
	}
}


function SelectRowHandler(evt) {
	
	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	if (rowObj.tagName != "TH") {
		if (eSrc.tagName != "A") eSrc=websys_getParentElement(eSrc);
		
		if (eSrc.tagName != "A") return;
		var rowsel=rowObj.rowIndex;
		
		return false;
	
	}
} 


document.body.onload = DocumentLoadHandler;
