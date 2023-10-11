/**
*AdjustStatPrint.js
*库存调整统计打印及导出JS
*/
var gUserId = session['LOGON.USERID'];
function PrintAdjustStat(ParStr)
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

	fileName="{DHCST_AdjustStat_Detail_Common.raq(StartDate="+StartDate+";EndDate="+EndDate+";StkType="+StkType+";StkGrpType="+StkGrpType+";Loc="+LocID+";ReasonDr="+ReasonID+";ItmDr="+InciID+";User="+gUserId+")}";
	DHCCPM_RQDirectPrint(fileName);
}

function ExportAdjustStat(ParStr)
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
	
	fileName="DHCST_AdjustStat.raq&StartDate="+StartDate+"&EndDate="+EndDate+"&StkType="+StkType+"&StkGrpType="+StkGrpType+"&Loc="+LocID+"&ReasonDr="+ReasonID+"&ItmDr="+InciID+"&User="+gUserId;
	DHCCPM_RQPrint(fileName);
}