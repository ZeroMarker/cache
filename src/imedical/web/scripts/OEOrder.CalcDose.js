// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var DoseQty="";

function UnitLookUpHandler(str) {
	//alert(str);
	var lu = str.split("^");	
	var obj=document.getElementById("UnitCode");
	if(obj) obj.value=lu[1];
}

function PlusMinusSelectHandler(str) {
	var lu = str.split("^");	
	var obj=document.getElementById("PlusMinus");
	if(obj) obj.value=lu[1];
}

function UpdateClickHandler() {

	var obj=document.getElementById("HidMRObsHeight");
	if((obj)&&(obj.value!="")&&(isNaN(obj.value))) {
		alert(t['MRObsHeight']+" "+t['XINVALID'])
		return false;
	}
	if(obj) Height=obj.value;
	var obj=document.getElementById("HidMRObsWeight");
	if((obj)&&(obj.value!="")&&(isNaN(obj.value))) {
		alert(t['MRObsWeight']+" "+t['XINVALID'])
		return false;
	}
	if(obj) Weight=obj.value;

	var parwin=window.opener;
	if(parwin) {
		var obj=parwin.document.getElementById("OEORIDoseQty");
		if((obj)&&(DoseQty!="")) {
			obj.value=DoseQty;
			obj.onchange();
		}
		var obj=parwin.document.getElementById("FlowQuantity");
		if((obj)&&(DoseQty!="")) {
			obj.value=DoseQty;
			//obj.onchange();
		}
		//log 62033
		var rowidx=document.getElementById("rowidx");
		if (rowidx) rowidx=rowidx.value;
		var obj=parwin.document.getElementById("Dosagez"+rowidx);
		if((obj)&&(DoseQty!="")) {
			obj.value=DoseQty;
			parwin.DoseQtyChangeHandler(rowidx);
		} 
		var obj=parwin.document.getElementById("IVVolumez"+rowidx);
		if((obj)&&(DoseQty!="")) {
			obj.value=DoseQty;
			parwin.SetQuantity(rowidx);
		}
		if((parwin.opener)&&(parwin.opener.top)&&(parwin.opener.top.frames["TRAK_main"])&&(parwin.opener.top.frames["TRAK_main"].frames["oeorder_entry"])) {
			
			var obj1=parwin.opener.top.frames["TRAK_main"].frames["oeorder_entry"].document.getElementById("MRObsWeight");
			if((obj1)&&(obj1.value)!="") {
				obj1.value=Weight;
			}

			var obj2=parwin.opener.top.frames["TRAK_main"].frames["oeorder_entry"].document.getElementById("MRObsHeight");
			if((obj2)&&(obj2.value)!="") {
				obj2.value=Height;
			}
			

		}
		
		else if((window.opener)&&(window.opener.top)&&(window.opener.top.frames["TRAK_main"])&&(window.opener.top.frames["TRAK_main"].frames["oeorder_entry"])) { 
			var obj1=window.opener.top.frames["TRAK_main"].frames["oeorder_entry"].document.getElementById("MRObsWeight");
			if((obj1)&&(obj1.value)!="") {
				obj1.value=Weight;
			}

			var obj2=window.opener.top.frames["TRAK_main"].frames["oeorder_entry"].document.getElementById("MRObsHeight");
			if((obj2)&&(obj2.value)!="") {
				obj2.value=Height;
			}

		}
		
		
	

	}
	return Update_click();
}


function CalculateClickHandler(str) {	
	var Height="";
	var Weight=""
	var BMI="";
	var BSA="";
	var Freq="";
	var Unit="";
	var Dose="";
	var DoseUnit="";
	var TotDoseAdm="";
	var TotDoseDay="";
	var Factor=1;
	var CFFactor=1;
	var age=0;
	var SerumCreatinine=1;
	var sex="";

	var obj=document.getElementById("HidMRObsHeight");
	if((obj)&&(obj.value!="")&&(isNaN(obj.value))) {
		alert(t['MRObsHeight']+" "+t['XINVALID'])
		return false;
	}
	if(obj) Height=obj.value;
	var obj=document.getElementById("HidMRObsWeight");
	if((obj)&&(obj.value!="")&&(isNaN(obj.value))) {
		alert(t['MRObsWeight']+" "+t['XINVALID'])
		return false;
	}
	if(obj) Weight=obj.value;
	var obj=document.getElementById("HidBMI");
	if(obj) BMI=obj.value;
	var obj=document.getElementById("HidBSA");
	if(obj) BSA=obj.value;
	var obj=document.getElementById("FreqFactor");
	if(obj) Freq=obj.value;
	var obj=document.getElementById("Dose");
	if(obj) Dose=obj.value;
	if((obj)&&(obj.className=="clsInvalid")) {
		alert(t['Dose']+" "+t['XINVALID'])
		return false;
	}

	var obj=document.getElementById("UnitCode");
	if(obj) Unit=obj.value;
	if((obj)&&((obj.className=="clsInvalid")||(obj.value==""))) {
		alert(t['Unit']+" "+t['XINVALID'])
		return false;
	}
	var obj=document.getElementById("HidCTUOMDesc");
	if(obj) DoseUnit=obj.value;

	var pmobj=document.getElementById("PlusMinus");
	var pobj=document.getElementById("Percentage");

	if((pmobj)&&(pmobj.className=="clsInvalid")) {
		alert(t['PlusMinus']+" "+t['XINVALID'])
		return false;
	}
	
	if((pobj)&&(pobj.className=="clsInvalid")) {
		alert(t['Percentage']+" "+t['XINVALID'])
		return false;
	}

	if((pmobj)&&(pmobj.value!="")&&(pobj)&&(pobj.value!="")) {
		if(pmobj.value=="+") {
			Factor=(Factor+(parseInt(pobj.value)/100));
		}

		else if(pmobj.value=="-") {
			if(parseInt(pobj.value)>=100) {
				alert(t['INV_ADJ']);
				return false;
			}
			Factor=(Factor-(parseInt(pobj.value)/100));
		}
	}

	if((Unit=="KDA")||(Unit=="KDO")) {
		if((Dose=="")||(Weight=="")||(Freq=="")) {
			alert(t['Dose']+", "+t['MRObsWeight']+t['AND']+t['Frequency']+t['NULL_VALUE']);
			DoseQty="";
			return false;
		}
	}
	if((Unit=="MDA")||(Unit=="MDO")) {
		if((Dose=="")||(BSA=="")||(Freq=="")) {
			alert(t['Dose']+", "+t['BSA']+t['AND']+t['Frequency']+t['NULL_VALUE']);
			DoseQty="";
			return false;
		}
	}
	if(Unit=="D") {
		if((Dose=="")||(Freq=="")) {
			alert(t['Dose']+t['AND']+t['Frequency']+t['NULL_VALUE']);
			DoseQty="";
			return false;
		}
	}
	if(Unit=="KDA") {
		TotDoseAdm=(Dose*Weight)/Freq;
		TotDoseDay=Dose*Weight;
	}
	else if(Unit=="KDO") {
		TotDoseAdm=Dose*Weight;
		TotDoseDay=Dose*Weight*Freq;
	}
	else if(Unit=="MDA") {
		TotDoseAdm=(Dose*BSA)/Freq;
		TotDoseDay=Dose*BSA;
	}
	else if(Unit=="MDO") {
		TotDoseAdm=Dose*BSA;
		TotDoseDay=Dose*BSA*Freq;
	}
	else if(Unit=="D") {
		TotDoseAdm=Dose/Freq;
		TotDoseDay=Dose;
	}
	
	else if(Unit=="PD") {
		var obj=document.getElementById("Calvert");
		if((obj)&&(obj.checked)) {
			var aobj=document.getElementById("age");
			if((aobj)&&(aobj.value!="")) age=aobj.value;
			
			var scobj=document.getElementById("SerumCreatinine");
			if((scobj)&&(scobj.value!="")) SerumCreatinine=scobj.value;

			var sobj=document.getElementById("sex");
			if((sobj)&&(sobj.value!="")) sex=sobj.value;	
	
			CFFactor=(140-parseInt(age))*parseFloat(Weight)/(72*parseFloat(SerumCreatinine));
			if (sex=="F") CFFactor=parseFloat(CFFactor)*0.85;
			CFFactor=parseFloat(CFFactor)+25;
		}
		TotDoseAdm=Dose*CFFactor;
		TotDoseDay=Dose*Freq*CFFactor;
	}
	
	//Log 59635 PeterC 20/06/06
	TotDoseAdm=Rounding(TotDoseAdm*Factor);
	TotDoseDay=Rounding(TotDoseDay*Factor);
	DoseQty=TotDoseAdm;

	var obj=document.getElementById("TotalDoseAdmin");
	if(obj) obj.innerText=TotDoseAdm+" "+DoseUnit;

	var obj=document.getElementById("TotalDoseDay");
	if(obj) obj.innerText=TotDoseDay+" "+DoseUnit;
}

function Rounding(num) {
  return Math.round(num*100)/100;
}

function RefreshPageHandler() {
	var OEORIItmMastDR,PatientID,EpisodeID,mradm,CTUOMDesc,Dose,Frequency,HidBSAFormula,rowidx="";
	var MRObsHeight="";
	var MRObsWeight="";
	var obj=document.getElementById("OEORIItmMastDR");
	if ((obj)&&(obj.value!="")) OEORIItmMastDR=obj.value;
	var obj=document.getElementById("PatientID");
	if ((obj)&&(obj.value!="")) PatientID=obj.value;
	var obj=document.getElementById("EpisodeID");
	if ((obj)&&(obj.value!="")) EpisodeID=obj.value;
	var obj=document.getElementById("mradm");
	if ((obj)&&(obj.value!="")) mradm=obj.value;
	var obj=document.getElementById("CTUOMDesc");
	if ((obj)&&(obj.value!="")) CTUOMDesc=obj.value;
	var obj=document.getElementById("MRObsHeight");
	if ((obj)&&(obj.value!="")) MRObsHeight=obj.value;
	var obj=document.getElementById("MRObsWeight");
	if ((obj)&&(obj.value!="")) MRObsWeight=obj.value;
	var obj=document.getElementById("Dose");
	if ((obj)&&(obj.value!="")) Dose=obj.value;
	var obj=document.getElementById("Frequency");
	if ((obj)&&(obj.value!="")) Frequency=obj.value;
	var obj=document.getElementById("HidBSAFormula");
	if ((obj)&&(obj.value!="")) HidBSAFormula=obj.value;
	var obj=document.getElementById("rowidx");
	if ((obj)&&(obj.value!="")) rowidx=obj.value;
	
	//alert("websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CalcDose&OEORIItmMastDR="+OEORIItmMastDR+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&PatientBanner=1"+"&CTUOMDesc="+CTUOMDesc+"&MRObsHeight="+MRObsHeight+"&MRObsWeight="+MRObsWeight+"&Dose="+Dose+"&Frequency="+Frequency);
  	window.location="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CalcDose&OEORIItmMastDR="+OEORIItmMastDR+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&PatientBanner=1"+"&CTUOMDesc="+CTUOMDesc+"&MRObsHeight="+MRObsHeight+"&MRObsWeight="+MRObsWeight+"&Height="+MRObsHeight+"&Weight="+MRObsWeight+"&Dose="+Dose+"&Frequency="+Frequency+"&HidBSAFormula="+HidBSAFormula+"&rowidx="+rowidx;

}

//log 61690
function BSAFormReturn(Str){
	var lu = Str.split("^");
	var BSA=document.getElementById("BSA");
	var HidBSA=document.getElementById("HidBSA");
	var HidBSAFormula=document.getElementById("HidBSAFormula");
	if(HidBSAFormula) HidBSAFormula.value=lu[1];
	var BSAround=lu[2]*1000;
	BSAround=parseInt(BSAround);
	BSAround=parseFloat(BSAround/1000);
	if (BSA) BSA.innerText=BSAround;
	if (HidBSA) HidBSA.value=BSAround;
	return false;
}

function CalvertFormulaHandler() {
	var obj=document.getElementById("Calvert");
	if((obj)&&(obj.checked)) {
		var obj=document.getElementById("HidMRObsWeight");
		if(((obj)&&(obj.value==""))||((obj.value!="")&&(isNaN(obj.value)))) {
			alert(t['MRObsWeight']+" "+t['XINVALID'])
			return false;
		}
		var obj=document.getElementById("SerumCreatinine");

		if(!obj) {
			alert(t['SerumCreatinine']+" "+t['XMISSING']);
			return false;
		}
		if(((obj)&&(obj.value==""))||((obj.value!="")&&(isNaN(obj.value)))) {
			alert(t['SerumCreatinine']+" "+t['XINVALID']);
			return false;
		}
		var obj=document.getElementById("Unit");
		if(obj) {
			obj.value="PD";
			obj.onchange();
		}
	}
}

var obj=document.getElementById("Calculate");
if(obj) obj.onclick=CalculateClickHandler;

var obj=document.getElementById("Calvert");
if(obj) obj.onclick=CalvertFormulaHandler;

var obj=document.getElementById("Update");
if(obj) obj.onclick=UpdateClickHandler;

var obj=document.getElementById("MRObsHeight");
if(obj) obj.onchange=RefreshPageHandler;

var obj=document.getElementById("MRObsWeight");
if(obj) obj.onchange=RefreshPageHandler;

