// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function FindClickHandler(e) {
	var Summary=""; var ClosedProblems=""; var AcrossEpisodes="";
	var PathwayDesc="";
	var HospDesc="";
	var Location="";
	var CLPTDesc="";
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	else if (eSrc.tagName=="U") eSrc=websys_getParentElement(eSrc);
	var SummaryObj=document.getElementById("SummaryView");
	if (SummaryObj&&SummaryObj.checked) Summary="on";
	var CPObj=document.getElementById("ClosedProblems")
	if (CPObj&&CPObj.checked) ClosedProblems="on";
	var AEObj=document.getElementById("AcrossEpisodes")
	if (AEObj&&AEObj.checked) AcrossEpisodes="on";
	var PDObj=document.getElementById("PathwayDesc")
	if ((PDObj)&&(PDObj.value!="")) PathwayDesc=PDObj.value;
	//Log 62414 PeterC 16/02/07
	var HDObj=document.getElementById("HOSPDesc")
	if ((HDObj)&&(HDObj.value!="")) HospDesc=HDObj.value;
	var LObj=document.getElementById("Location")
	if ((LObj)&&(LObj.value!="")) Location=LObj.value;
	var CDObj=document.getElementById("CLPTDesc")
	if ((CDObj)&&(CDObj.value!="")) CLPTDesc=CDObj.value;
	var url=eSrc.href;
	if (url&&SummaryObj&&CPObj&&AEObj) eSrc.href=url+"&SummaryView="+Summary+"&ClosedProblems="+ClosedProblems+"&AcrossEpisodes="+AcrossEpisodes+"&PathwayDesc="+PathwayDesc+"&HOSPDesc="+HospDesc+"&Location="+Location+"&CLPTDesc="+CLPTDesc;
}

function FindClickHandlerFromAppt() {
	var Summary=""; var ClosedProblems=""; var AcrossEpisodes="";
	var PathwayDesc="";
	var HospDesc="";
	var Location="";
	var CLPTDesc="";
	var SummaryObj=document.getElementById("SummaryView");
	if (SummaryObj&&SummaryObj.checked) Summary="on";
	var CPObj=document.getElementById("ClosedProblems")
	if (CPObj&&CPObj.checked) ClosedProblems="on";
	var AEObj=document.getElementById("AcrossEpisodes")
	if (AEObj&&AEObj.checked) AcrossEpisodes="on";
	var PDObj=document.getElementById("PathwayDesc")
	if ((PDObj)&&(PDObj.value!="")) PathwayDesc=PDObj.value;
	//Log 62414 PeterC 16/02/07
	var HDObj=document.getElementById("HOSPDesc")
	if ((HDObj)&&(HDObj.value!="")) HospDesc=HDObj.value;
	var LObj=document.getElementById("Location")
	if ((LObj)&&(LObj.value!="")) Location=LObj.value;
	var CDObj=document.getElementById("CLPTDesc")
	if ((CDObj)&&(CDObj.value!="")) CLPTDesc=CDObj.value;
	var FObj=document.getElementById("Find")
	var url=FObj.href;
	if (url&&SummaryObj&&CPObj&&AEObj) FObj.href=url+"&SummaryView="+Summary+"&ClosedProblems="+ClosedProblems+"&AcrossEpisodes="+AcrossEpisodes+"&PathwayDesc="+PathwayDesc+"&HOSPDesc="+HospDesc+"&Location="+Location+"&CLPTDesc="+CLPTDesc;
	return Find_click();
}


function ProblemLookUpHandler(txt) {
	
	var adata=txt.split("^");
	var Desc=adata[1];
	var obj=document.getElementById("PathwayDesc");
	if (obj) obj.value=Desc;
}

function UpdateClickHandler(e) {
	var objAE = document.getElementById("AcrossEpisodes");
	if (!objAE || (objAE && !objAE.checked)) {
		var mradm = document.getElementById("mradm");
		var obj = document.getElementById("MRADMCarePlanStartDate");
		if (obj) MRAdmStDate=obj.value
		var obj = document.getElementById("MRADMCarePlanReviewDate");
		if (obj) MRAdmRevDate=obj.value
		var obj = document.getElementById("MRADMCarePlanEndDate");
		if (obj) MRAdmEndDate=obj.value
	
		var lnk = "mrclinicalpathways.careplanupdate.csp?MRAdm="+mradm.value+"&MRAdmStDate="+MRAdmStDate+"&MRAdmRevDate="+MRAdmRevDate+"&MRAdmEndDate="+MRAdmEndDate
		websys_createWindow(lnk,"TRAK_hidden");
		FindClickHandler(e)
	} else {
		return false
	}
}

function AcrossEpClickHandler() {
	var disable=false;
	var objAE = document.getElementById("AcrossEpisodes");
	if (objAE && objAE.checked) disable=true
	var obj = document.getElementById("MRADMCarePlanStartDate");
	if (obj) EnableDisableField("MRADMCarePlanStartDate",disable)
	var obj = document.getElementById("MRADMCarePlanReviewDate");
	if (obj) EnableDisableField("MRADMCarePlanReviewDate",disable)
	var obj = document.getElementById("MRADMCarePlanEndDate");
	if (obj) EnableDisableField("MRADMCarePlanEndDate",disable)
	var obj = document.getElementById("Update");
	if (obj) EnableDisableField("Update",disable)
}

function EnableDisableField(fldName,val) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = val;
		if (fld.disabled==false){ 
			fld.className = "";
		} else {
			fld.className = "disabledField";
		}
	}
}

function BodyLoadHandler() {
	var findObj=document.getElementById("Find");
	if (findObj) findObj.onclick=FindClickHandler;
	
	var updObj=document.getElementById("Update");
	if (updObj) updObj.onclick=UpdateClickHandler;
	
	var updObj=document.getElementById("AcrossEpisodes");
	if (updObj) updObj.onclick=AcrossEpClickHandler;
	
	AcrossEpClickHandler();
	//Log 62414 PeterC 21/02/07
	var NewObj=document.getElementById("NewClinPathWays");
	//Log 62816 PeterC 20/03/07
	if((NewObj)&&(NewObj.value=="")) {
		var RObj=document.getElementById("Reschedule");
		if (RObj) {
			RObj.style.visibility = "hidden";
			RObj.onclick=BlankClickHandler;
			RObj.disabled=true;
		}
	}
	var eTABLE=document.getElementById("tMRClinicalPathways_CarePlanList");
	if ((eTABLE)&&(NewObj)&&(NewObj.value=="Y")) {
		var VObj=document.getElementById("VisitStatus");
		if ((VObj)&&(VObj.value=="C")) {
			alert(t['CancelledEpisode']);
			var NObj=document.getElementById("New");
			if (NObj) {
				NObj.onclick=BlankClickHandler;
				NObj.disabled=true;
			}
		}
		for (var i=1; i<eTABLE.rows.length; i++) {
			var GObj=document.getElementById("DAYSDescz"+i);
			if(GObj) {
				GObj.onclick=BlankClickHandler;
				GObj.disabled=true;
			}
		}
	}
	//Log 62816 PeterC 16/03/07
	var eTABLE=document.getElementById("tMRClinicalPathways_CarePlanList");
	if (eTABLE) {
		var LLObj=document.getElementById("ListLength");
		if(LLObj) LLObj.value=eTABLE.rows.length-1;

		for (var i=1; i<eTABLE.rows.length; i++) {
			var DObj=document.getElementById("DAYSRowIdz"+i);
			if((DObj)&&(DObj.value=="")) {
				var SObj=document.getElementById("selectz"+i);
				if(SObj) {
					SObj.style.visibility = "hidden";
				}
			}
		}
	}
	//Log 62816 PeterC 20/03/07
	var RObj=document.getElementById("Reschedule");
	if (RObj) RObj.onclick=RescheduleClickHandler;
}

function RescheduleClickHandler() {
	var SelCount=0;
	var PathwayID="";
	var eTABLE=document.getElementById("tMRClinicalPathways_CarePlanList");
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var SObj=document.getElementById("selectz"+i);
			if((SObj)&&(SObj.checked==true)) {
				var PIDObj=document.getElementById("PathwayIDz"+i);
				if((PIDObj)&&(PIDObj.value!="")) {
					if(PathwayID=="") PathwayID=PIDObj.value;
					else if(PIDObj.value!=PathwayID) {
						alert(t['MULTI_CP']);
						return false;
					}
				}
				SelCount++;
			}
		}
		if(SelCount==0) {
			alert(t['SELECT']);
			return false;
		}
		else{
			var ConfirmReschedule = confirm(t['RESCHEDULE']+"\n"+t['CONTINUE']);
			if (!ConfirmReschedule ) return false;
			else { return Reschedule_click();}
		}
	}
}


function BlankClickHandler() {
	return false;
}

function DeleteClickHandler(){
}
document.body.onload=BodyLoadHandler;