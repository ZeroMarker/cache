// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 53870 - AI - 27-09-2005 : js file for new component. Based on MRDiagnos.ListEMR plus for some same-frame csp handling.

var frm = document.forms["fMRDiagnos_ListOp"];

function DocumentLoadHandler() {
	var objNew=document.getElementById("new");
	var objPatID=document.getElementById("PatientID");
	var objID=document.getElementById("EpisodeID");
	
	if (objNew) {
		if (((objPatID)&&(objPatID.value==""))||((objID)&&(objID.value==""))) {
			objNew.disabled=true;
			objNew.onclick=LinkDisable;
		} else {
			objNew.onclick=NewClickHander;
		}
	}

/*
 removed when the Delete was taken off the list and put back on the EditOp component.

	// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
	for (var zid=1; zid<document.getElementById("tMRDiagnos_ListOp").rows.length; zid++) {
		var objCanUserDelete = document.getElementById('CanUserDeletez'+zid);
		if ((objCanUserDelete)&&(objCanUserDelete.value==1)) {
			var objDelete = document.getElementById('delete1z'+zid);
			if (objDelete) {
				objDelete.disabled=false;
			}
		} else {
			var objDelete = document.getElementById('delete1z'+zid);
			if (objDelete) {
				objDelete.disabled=true;
				objDelete.onclick=LinkDisable;
			}
		}
	}
	// end Log 46427
*/

	var objUpdate=document.getElementById("update1");
	if (objUpdate) objUpdate.onclick=updateClickHandler;

	var objTable=document.getElementById("tMRDiagnos_ListOp");
	if (objTable) objTable.onclick=ListClickHandler;

}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function updateClickHandler() {
	return update1_click();
}

function NewClickHander() {
	//alert(parent.frames+"^"+parent.frames["mrdiagnos_editop"]);
	//if ((parent)&&(parent.frames)&&(parent.frames["mrdiagnos_editop"])) {
	if ((parent)&&(parent.frames)) {
		var EpiID=document.getElementById("EpisodeID")
		if (EpiID) EpiID=EpiID.value;
		var PatID=document.getElementById("PatientID")
		if (PatID) PatID=PatID.value;
		var parref=document.getElementById("mradm");
		if (parref) parref=parref.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		//alert("currentlink :"+currentlink)
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=MRDiagnos.EditOp&"+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&CONTEXT="+CONTEXT;
		//alert(lnk)
		websys_createWindow(lnk,"mrdiagnos_editop","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		return false;
	}
}

function ListClickHandler(e) {
	var lnk="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var mradm=document.getElementById("mradm");
 	if (mradm) mradm=mradm.value;
   	var eSrc = websys_getSrcElement(e);
	
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc);
	}

	if ((parent.frames["mrdiagnos_editop"])&&(eSrc.id!="")) {
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("edit1z")==0) {
				eSrc.target = "mrdiagnos_editop";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=MRDiagnos.EditOp&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
			}

/*
 removed when the Delete was taken off the list and put back on the EditOp component.

			if (eSrc.id.indexOf("delete1z")==0) {
				// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
				var zid=eSrc.id.substr(eSrc.id.length-1,1);
				if (document.getElementById("delete1z"+zid).disabled) return false;
				// end Log 46427
				var rowid=document.getElementById("MRDIA_RowIdz"+zid);
				if (rowid) rowid=rowid.value;
				eSrc.target="_parent";
				//alert("href " + eSrc.href);

				var lnk="mrdiagnos.frames.csp?PARREF="+mradm+"&PatientID="+patid+"&ID="+rowid+"&EpisodeID="+epid+"&mradm="+mradm+"&PatientBanner=1";
				//alert("delete: "+lnk);

				eSrc.href=lnk;
			}
*/
		}
	}
	//alert(target);
	//return false;
}


document.body.onload = DocumentLoadHandler;
