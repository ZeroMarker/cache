// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAAdmContractCare_List");
var tbl=document.getElementById('tPAAdmContractCare_List')
	
function PAAdmContractCareListLoadHandler(e) {
	var numRows=tbl.rows.length;
	for (i=1;i<numRows;i++) {
		contrcarecid=document.getElementById("CONTCARE_RowIDz"+i);
		contrcarehidden=document.getElementById("activeid");
		if ((contrcarecid)&&(contrcarehidden)&&(contrcarehidden.value==contrcarecid.value)) {
			tbl.rows[i].className="clsRowPre";
		}
	}
	
	// rqg 28.07.03 L33993: If coming from "Coding screen", activeid field is assigned a value of "CODING" which is
	// necessary to disable the links DateFrom, New and Update buttons.
	var objDateFr=document.getElementById("CONTCARE_DateFrom");	 
	var objNew=document.getElementById("New1");
	var objUpdate=document.getElementById("update2");
	var objactiveid=document.getElementById("activeid");		// activeid set in QH DRG Coding custom script (orig log 33993)
	if ((objactiveid) && (objactiveid.value=="CODING")) {
		if (objNew) objNew.onclick=LinkDisable;
		// cjb 06/10/2004 45798 - don't disable the update button on the list otherwise you can't close the window!
		//if (objUpdate) objUpdate.onclick=LinkDisable;
	}
}

function LinkDisable(evt) {
	return false;
}

function SelectRowHandler(evt) {
	//L33993
	var objactiveid=document.getElementById("activeid");
	if ((objactiveid)&&(objactiveid.value=="CODING")) return false;

	//websys.List.js has already set the selected row into a variable called selectedRowObj
	var url="",objType,objID;
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.href) {
		var temp1=eSrc.href.split("&TWKFL")
		var temp2=eSrc.href.split("&ID")
		var url = temp1[0] + "&ID" + temp2[1];
			}
	if (eSrc.tagName=="A") {
		 if (eSrc.id.indexOf("CONTCARE_DateFromz")==0) {
			var eSrcAry=eSrc.id.split("z");
			//return true;
			//eSrc.target = "lower";
			//alert(eSrc.href);
			//var currentlink=eSrc.href.split("?");
			//alert(currentlink[1]);
			//location.href = "paadmcontractcare.csp&" + currentlink[1];
			//websys_createWindow("paadmcontractcare.csp&" + currentlink[1]);
			//websys_createWindow(url,"testname2","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes");
		}
	} else {
		if (eSrc.tagName=="TD") eSrc=eSrc.firstChild;
		var eSrcAry=eSrc.id.split("z");
		if (eSrc.children.length>0) {
			var eSrc=eSrc.firstChild;
			eSrcAry=eSrc.id.split("z");
		}
	}
	if (eSrcAry.length<=1) return false;
	var ID=document.getElementById('CONTCARE_RowIDz'+eSrcAry[1]).value;
	//var Clincode=document.getElementById('cliniccodez'+eSrcAry[1]).value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var PatientID=document.getElementById('PatientID').value;
	var TWKFL=document.getElementById('TWKFL').value;
	var TWKFLI=document.getElementById('TWKFLI').value;
	var PatientBanner=document.getElementById('BANNERPatientID');
	if ((PatientBanner)&&(PatientBanner.value!="")) PatientBanner=1;
	TWKFLI=TWKFLI-1;
		//location.href="paadmcontractcare.csp?ID="+ID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI
		if (TWKFL=="") {location.href="paadmcontractcare.csp?ID="+ID+"&EpisodeID="+EpisodeID+"&PAADMCONTCAREID="+ID+"&PatientBanner="+PatientBanner+"&PatientID="+PatientID;}
		else {location.href="websys.csp?ID="+ID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&PAADMCONTCAREID="+ID+"&PatientBanner="+PatientBanner+"&PatientID="+PatientID;}
	//}
	return false;
}


window.document.body.onload=PAAdmContractCareListLoadHandler;