// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function PAAdmDRGCodingDisplayLoadHandler() {
	//alert(" PAAdmDRGCodingDisplayLoadHandler  loaded");
	var objTViewWEISDetails=document.getElementById("TViewWEISDetails");
	if (objTViewWEISDetails) objTViewWEISDetails.onclick=ViewWEISDetailsScreen; 
	var objBannerLOS=document.getElementById("BANNERLengthofStay");
	if (objBannerLOS){
		var objTLOS=document.getElementById("TLOS");
		if (objTLOS) objTLOS.innerText=objBannerLOS.innerText;
	}
	CheckTWEISScore();  //Log 35894,36414
	//KK 13/July/2004 - L:44923
	var objDRGCode=document.getElementById("TDRGCode");
	if (objDRGCode) {
		if (objDRGCode.value=="XXX"){
			objDRGCode.innerText="";
			objDRGCode.value="";
			var objDRGDesc=document.getElementById("TDRGDesc");
			if (objDRGDesc) {
				objDRGDesc.innerText="";
				objDRGDesc.value="";
			}
		}
	}
}

//KK 13/Jun/2003 Log 35894,36414
function CheckTWEISScore() {
	//alert("Check T WEISScore");
	var objTWEISScore=document.getElementById("TMRADMTotalWIESScore");
	var objTViewWEISDetails=document.getElementById("TViewWEISDetails");

	if ((objTWEISScore)&&(objTWEISScore.tagName=="LABEL")&&(objTWEISScore.innerText!="")&&(objTWEISScore.innerText!=" ")) {
		if (objTViewWEISDetails) {
			objTViewWEISDetails.disabled=false;
		}
	} else {
		if (objTViewWEISDetails) {
			objTViewWEISDetails.disabled=true;
			objTViewWEISDetails.onclick=LinkDisable;
		}
	}
	return true;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}
function ViewWEISDetailsScreen(evt) {
	var el = websys_getSrcElement(evt);
	if (!el.disabled) {
		var EpisodeID; var MRAdmID; var DischDate;
		var objmradmid=document.getElementById("mradm");
		if (objmradmid) MRAdmID=objmradmid.value;
		var objEpisodeID=parent.frames["PAAdmDRGCoding"].document.getElementById("EpisodeID");
		if (objEpisodeID) EpisodeID=objEpisodeID.value;
		var objDischargeDate=parent.frames["PAAdmDRGCoding"].document.getElementById("DischargeDate");
		if (objDischargeDate) DischDate=objDischargeDate.value;
		//alert(DischDate);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.DRGCodingWEISDetails"+"&episodeid="+EpisodeID+"&mradmid="+MRAdmID+"&DischDate="+DischDate;
		websys_lu(url,false,"width=650,height=460,top=30,left=60");
	}
	return false;
}
document.body.onload = PAAdmDRGCodingDisplayLoadHandler;
