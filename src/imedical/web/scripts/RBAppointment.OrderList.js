//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function SelectRowHandler(evt) {
	var form=document.forms["fRBAppointment_OrderList"];
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	//var	row=arry[arry.length-1];
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var PatientID=""; var EpisodeID=""; var mradm=""; var ORIRowID=""; var url=""; var ApptID=""
	var ObservationGroupID=""; var QuestionnaireID=""; var OEOrdExecID=""; var OEORISeqNo=""; var TWKFL="";
	//alert("hello "+eSrcAry[0]+"row "+row);
	if ((form)&&(row)) {
		var pobj=form.document.getElementById("PatientID");
		if (pobj) PatientID=pobj.value;
		var eobj=form.document.getElementById("EpisodeID");
		if (eobj) EpisodeID=eobj.value;
		var mobj=form.document.getElementById("mradm");
		if (mobj) mradm=mobj.value;
		var aobj=form.document.getElementById("ApptID");
		if (aobj) ApptID=aobj.value;
		var oriobj=form.document.getElementById("ORIRowIDz"+row);
		if (oriobj) ORIRowID=oriobj.value;
		var obsobj=form.document.getElementById("ObservationGroupIDz"+row);
		if (obsobj) ObservationGroupID=obsobj.value;
		var Qobj=form.document.getElementById("QuestionnaireIDz"+row);
		if (Qobj) QuestionnaireID=Qobj.value;
		var execobj=document.getElementById("OEOrdExecIDz"+row);
		if (execobj) OEOrdExecID=execobj.value;
		var SQobj=form.document.getElementById("OEORISeqNoz"+row);
		if (SQobj) OEORISeqNo=SQobj.value;
		var arcobj=form.document.getElementById("ARCIMRowIdz"+row);
		if (arcobj) ARCIMRowID=arcobj.value;
		var Tobj=form.document.getElementById("TWKFLEL");
		if (Tobj) TWKFL=Tobj.value;
		//var QuestionnaireID=""
		//alert(OEORISeqNo+" qid "+QuestionnaireID+"obsid "+ObservationGroupID)

		if (eSrcAry[0]=="OEORETimeExecuted") {
			if (OEORISeqNo!="")
			{
				url="oeordexec.linkedorders.csp?PatientBanner=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PARREF="+ORIRowID+"&seqno="+OEORISeqNo;
			} else if ((QuestionnaireID=="")&&(ObservationGroupID=="")) {
				url="oeordexec.edit.csp?PatientBanner=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PARREF="+ORIRowID+"&ID="+OEOrdExecID+"&ApptID="+ApptID;

			} else {
				//This was done for RIE and it's no longer in use
				//url = "ssuserdefwindowcontrols.questionnaire.csp?QuestionnaireID="+QuestionnaireID+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&oeordexecid="+OEOrdExecID+"&ObsGrpID="+ObservationGroupID;
				url="websys.csp?TWKFL="+TWKFL+"&PatientBanner=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&QuestionnaireID="+QuestionnaireID+"&oeordexecid="+OEOrdExecID+"&ObsGrpID="+ObservationGroupID+"&PARREF="+ORIRowID;
				//alert("url ="+url);
			}
			// was here before
			// websys_createWindow(url, "","top=0,width=500,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				websys_createWindow(url, "","top=30,left=20,width=600,height=450,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				return false;

	   	}

	   	if (eSrcAry[0]=="ARCIMDesc"){

			//url = "oeorder.mainloop.csp?&ID="+OrdItem+"&EpisodeID="+EpisodeID+"&OEORIItmMastDR="+ArcimDR+"&PatientID="+PatientID+"&AN=&CONTEXT="+CONTEXT+"&mradm="+mradm+"&SummaryFlag="+"&UpdateFrom=Pharmacy.Presc.Edit";
			url = "oeorder.mainloop.csp?&ID="+ORIRowID+"&EpisodeID="+EpisodeID+"&OEORIItmMastDR="+ARCIMRowID+"&PatientID="+PatientID+"&AN=&CONTEXT="+session['CONTEXT']+"&mradm="+mradm+"&SummaryFlag="+"&UpdateFrom=RBAppointment.OrderList";
			websys_createWindow(url, "","top=0,width=500,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			return false;
	   	}
			//alert("url ="+url);
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			//websys_createWindow(url, "","top=0,width=500,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			return false;
		}
}
