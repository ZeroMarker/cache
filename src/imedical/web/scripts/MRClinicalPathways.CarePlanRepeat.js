// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var UObj=document.getElementById("Update");
	if(UObj) UObj.onclick=UpdateClickHandler;


}

function UpdateClickHandler() {
	
	var CurrEpID="";
	var ReasForRept="";
	var SttDate="";
	var RepeatDetails="";
	var FinishCount="";
	var PatientID="";
	var RepeatIDs="";
	var EpisodeID="";
	var mradm="";
	var CurrRepeat="";
	var RepeatID="";
	
	var CObj=document.getElementById("CurrEpID");
	if ((CObj)&&(CObj.value!="")) CurrEpID=CObj.value;

	var RObj=document.getElementById("ReasForRept");
	if ((RObj)&&(RObj.value!="")) ReasForRept=RObj.value;

	var SObj=document.getElementById("SttDate");
	if ((SObj)&&(SObj.value!="")) SttDate=SObj.value;

	var HSObj=document.getElementById("hidCurrDate");
	if ((HSObj)&&(HSObj.value!="")&&(SttDate=="")) SttDate=HSObj.value;

	var RDObj=document.getElementById("RepeatDetails");
	if ((RDObj)&&(RDObj.value!="")) RepeatDetails=RDObj.value;

	var FObj=document.getElementById("FinishCount");
	if ((FObj)&&(FObj.value!="")) FinishCount=FObj.value;

	var PObj=document.getElementById("PatientID");
	if ((PObj)&&(PObj.value!="")) PatientID=PObj.value;

	var RPObj=document.getElementById("RepeatIDs");
	if ((RPObj)&&(RPObj.value!="")) RepeatIDs=RPObj.value;

	var EObj=document.getElementById("EpisodeID");
	if ((EObj)&&(EObj.value!="")) EpisodeID=EObj.value;

	var MObj=document.getElementById("mradm");
	if ((MObj)&&(MObj.value!="")) mradm=MObj.value;

	var CRObj=document.getElementById("CurrRepeat");
	if ((CRObj)&&(CRObj.value!="")) CurrRepeat=CRObj.value;

	var RRIObj=document.getElementById("ReasForReptID");
	if ((RRIObj)&&(RRIObj.value!="")) RepeatID=RRIObj.value;

	CurrRepeat++;

	if((CurrEpID!="")&&(ReasForRept!="")&&(SttDate!="")) {
		RepeatDetails=RepeatDetails+CurrEpID+"^"+RepeatID+"^"+SttDate+","
	}
	
	//alert(RepeatDetails);
	if(FinishCount=="Y") {
		//alert("Modify Parent. Done");
		if (window.opener) {
			var win=window.opener;
			var PRDObj=win.document.getElementById("RepeatDetails");
			if(PRDObj) PRDObj.value=RepeatDetails;
		}
		window.close();
		return win.Update_click();
		//return;
	}
	else {
		//alert("Not Done. Continue");
		var url="mrclinicalpathways.careplanrepeat.csp?RepeatIDs="+RepeatIDs+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&CurrRepeat="+CurrRepeat+"&PatientBanner=1&RepeatDetails="+RepeatDetails+"&ReasForReptID="+RepeatID;
		//alert(url);
        	window.location=url;
		return;
	}
}

function ReaReptLookUp(str) {
	var lu=str.split("^");
	var id=lu[1];
	var desc=lu[0];

	var rpobj=document.getElementById("ReasForRept");
	if (rpobj) rpobj.value=desc;

	var rpdobj=document.getElementById("ReasForReptID");
	if (rpdobj) rpdobj.value=id;
}

document.body.onload = BodyLoadHandler;

