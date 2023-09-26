//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

OldTariffDescKeyDown="";
objDRGCode=document.getElementById("DRGCode");
objTARNormalTariff=document.getElementById("TARNormalTariff");
objTAROneDayTariff=document.getElementById("TAROneDayTariff");
objTARDayHospitalTariff=document.getElementById("TARDayHospitalTariff");
objTARLimitDay=document.getElementById("TARLimitDay");
objTARExtraTariffPerDay=document.getElementById("TARExtraTariffPerDay");
objTARReabilitationTariff=document.getElementById("TARReabilitationTariff");
objTARReabilitaionLimitDay=document.getElementById("TARReabilitaionLimitDay");
objTARReabilitaionExtraTariffPerDay=document.getElementById("TARReabilitaionExtraTariffPerDa");
objTARClass1=document.getElementById("TARClass1");
objTARClass2=document.getElementById("TARClass2");
objTARClass3=document.getElementById("TARClass3");
objTARMedTarget=document.getElementById("TARMedTarget");
objTARSameDayOneDay=document.getElementById("TARSameDayOneDay");
objTARExtraHighTrimPoint=document.getElementById("TARExtraHighTrimPoint");
objTARKind=document.getElementById("TARKind");
objTARHITHOutlier=document.getElementById("TARHITHOutlier");

function BodyLoadHandler() {
	if (objDRGCode) {
		OldTariffDescKeyDown=objDRGCode.onkeydown;
		objDRGCode.onkeydown=DRGCodeKeyDown;
	}
}

function DRGCodeKeyDown() {

	if (typeof OldTariffDescKeyDown!="function") origcode=new Function(OldTariffDescKeyDown); 
	if (OldTariffDescKeyDown()==false) return false;
	if (objTARNormalTariff) objTARNormalTariff.value = "";
	if (objTAROneDayTariff) objTAROneDayTariff.value = "";
	if (objTARDayHospitalTariff) objTARDayHospitalTariff.value = "";
	if (objTARLimitDay) objTARLimitDay.value = "";
	if (objTARExtraTariffPerDay) objTARExtraTariffPerDay.value = "";
	if (objTARReabilitationTariff) objTARReabilitationTariff.value = "";
	if (objTARReabilitaionLimitDay) objTARReabilitaionLimitDay.value = "";
	if (objTARReabilitaionExtraTariffPerDay) objTARReabilitaionExtraTariffPerDay.value = "";
	if (objTARClass1) objTARClass1.value = "";
	if (objTARClass2) objTARClass2.value = "";
	if (objTARClass3) objTARClass3.value = "";
	if (objTARMedTarget) objTARMedTarget.value = "";
	if (objTARSameDayOneDay) objTARSameDayOneDay.value = "";
	if (objTARExtraHighTrimPoint) objTARExtraHighTrimPoint.value = "";
	if (objTARKind) objTARKind.value = "";
	if (objTARHITHOutlier) objTARHITHOutlier.value = "";
}

function DRGTariffLookUpHandler(str) {
	//alert("str="+str);
 	var lu = str.split("^");
	if ((lu[2]!="")&&(objDRGCode)) objDRGCode.value = lu[2];
	if ((lu[3]!="")&&(objTARNormalTariff)) objTARNormalTariff.value = lu[3];
	if ((lu[4]!="")&&(objTAROneDayTariff)) objTAROneDayTariff.value = lu[4];
	if ((lu[5]!="")&&(objTARDayHospitalTariff)) objTARDayHospitalTariff.value = lu[5];
	if ((lu[6]!="")&&(objTARLimitDay)) objTARLimitDay.value = lu[6];
	if ((lu[7]!="")&&(objTARExtraTariffPerDay)) objTARExtraTariffPerDay.value = lu[7];
	if ((lu[8]!="")&&(objTARReabilitationTariff)) objTARReabilitationTariff.value = lu[8];
	if ((lu[9]!="")&&(objTARReabilitaionLimitDay)) objTARReabilitaionLimitDay.value = lu[9];
	if ((lu[10]!="")&&(objTARReabilitaionExtraTariffPerDay)) objTARReabilitaionExtraTariffPerDay.value = lu[10];
	if ((lu[11]!="")&&(objTARClass1)) objTARClass1.value = lu[11];
	if ((lu[12]!="")&&(objTARClass2)) objTARClass2.value = lu[12];
	if ((lu[13]!="")&&(objTARClass3)) objTARClass3.value = lu[13];
	if ((lu[14]!="")&&(objTARMedTarget)) objTARMedTarget.value = lu[14];
	if ((lu[15]!="")&&(objTARSameDayOneDay)) objTARSameDayOneDay.value = lu[15];
	if ((lu[16]!="")&&(objTARExtraHighTrimPoint)) objTARExtraHighTrimPoint.value = lu[16];
	if ((lu[17]!="")&&(objTARKind)) objTARKind.value = lu[17];
	if ((lu[18]!="")&&(objTARHITHOutlier)) objTARHITHOutlier.value = lu[18];
}


document.body.onload=BodyLoadHandler;

