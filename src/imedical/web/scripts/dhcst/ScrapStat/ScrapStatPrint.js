function PrintScrapStat(ParStr)
{
	if(ParStr==null || ParStr==''){
	return;
	}
	var StrArr=ParStr.split("^");
	var StartDate=StrArr[0];
	var EndDate=StrArr[1];
	var LocID=StrArr[3];
	var StkType=StrArr[2];
	var InciID=StrArr[4];
	var ReasonID=StrArr[5];
	var StkGrpType=StrArr[6];
	var LocDesc=StrArr[7];
	var User=StrArr[8];

	fileName="{DHCST_ScrapStat.raq(StartDate="+StartDate+";EndDate="+EndDate+";StkType="+StkType+";StkGrpType="+StkGrpType+";Loc="+LocID+";ReasonDr="+ReasonID+";ItmDr="+InciID+";LocDesc="+LocDesc+";HospDesc="+App_LogonHospDesc+";User="+User+")}";
	DHCCPM_RQDirectPrint(fileName);
}
function ExportScrapStat(ParStr)
{
	if(ParStr==null || ParStr==''){
	return;
	}
	var StrArr=ParStr.split("^");
	var StartDate=StrArr[0];
	var EndDate=StrArr[1];
	var LocID=StrArr[3];
	var StkType=StrArr[2];
	var InciID=StrArr[4];
	var ReasonID=StrArr[5];
	var StkGrpType=StrArr[6];
	var LocDesc=StrArr[7];
	var User=StrArr[8];

	fileName="DHCST_ScrapStat.raq&StartDate="+StartDate+"&EndDate="+EndDate+"&StkType="+StkType+"&StkGrpType="+StkGrpType+"&Loc="+LocID+"&ReasonDr="+ReasonID+"&ItmDr="+InciID+"&LocDesc="+LocDesc+"&HospDesc="+App_LogonHospDesc+'&User='+User;
	DHCCPM_RQPrint(fileName);
}