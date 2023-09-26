// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


var frm = document.forms["fRBOperAdditionalStaff_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tRBOperAdditionalStaff_List"); 
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	if (tsc['New1']) websys_sckeys[tsc['New1']]=NewClickHander;	
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=updateClickHandler;	
	if (objTable) objTable.onclick=TableClickHandler;
}


function updateClickHandler() {
	if (window.name=="frm_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	return update1_click();
}

function TableClickHandler(e) {
	var patid="",epid="",parref="",id="",rowid="",TWKFLI="",context="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var rowid=document.getElementById("RBOPASRowId");
	if (rowid) rowid=rowid.value
	var TWKFLIobj=document.getElementById("TWKFLI");
	if (TWKFLIobj) TWKFLI=TWKFLIobj.value;
	context = document.getElementById("CONTEXT");
	if (context) context = context.value;
   	var eSrc = websys_getSrcElement(e);
	if (parent.frames["frm_edit"]) {
		if (eSrc.tagName=="IMG") { //tagnames like TD, TH etc...
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("RBOPASCareProvTypez")==0) { 
				eSrc.target = "frm_edit"; //frame target

				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=RBOperAdditionalStaff.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
				}
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"; //frame target

				if  (TWKFLI !="") { 
					TWKFLI = TWKFLI - 1;
					var linkParts = eSrc.href.split("&TWKFLI=");
					var linkParts2 = linkParts[1].split("&TRELOADID=");
					var newLink = linkParts[0] + "&TWKFLI=" + TWKFLI + "&CONTEXT=" + context + "&TRELOADID=" + linkParts2[1];
					eSrc.href=newLink;
				}
			}
		}
	}
}

function NewClickHander(e) {
	if ((parent)&&(parent.frames)&&(parent.frames["frm_edit"])) {
		var epid="",patid="",parref="";
		var epid=document.getElementById("EpisodeID")
		if (epid) epid=epid.value;
		var patid=document.getElementById("PatientID")
		if (patid) patid=patid.value;
		var parref=document.getElementById("PARREF");
	 	if (parref) parref=parref.value;
		var TWKFL=document.getElementById("TWKFL")
		if (TWKFL) TWKFL=TWKFL.value;
		var TWKFLI=document.getElementById("TWKFLI")
		if (TWKFLI) TWKFLI=TWKFLI.value;
		var context = document.getElementById("CONTEXT");
		if (context) context = context.value;

		//need to specify the link here, because New1 is a button and doesn't have a target attribute.  Use the websys_createwindow method
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=RBOperAdditionalStaff.Edit&" +"&PARREF="+parref+"&PatientID="+patid+"&EpisodeID="+epid+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+context;
		websys_createWindow(lnk,"frm_edit",""); //frame name is frm_edit
		return false;
	}
}

	


document.body.onload = DocumentLoadHandler;