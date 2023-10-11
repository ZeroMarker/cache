
jQuery(document).ready(function()
{
	defindTitleStyle();
	initEchartsObjMap();
	var ChartsPars=getElementValue("StartMonth")+","+getElementValue("EndMonth")+","+session['LOGON.CTLOCID']+","+session['LOGON.GROUPID']+","+getElementValue("UseLocDR")+","+getElementValue("EquipDR");
	//alert("ChartsPars="+ChartsPars)
	initChartsDefine("EQRevenueExpenditure",ChartsPars);
	refreshReport();
});
function initEchartsObjMap()
{
	EchartsObjMap["EQRevenueExpenditure"]="RevenueExpenditure";
}

function BFind_Clicked()
{
	var val="&ReportFileName=DHCEQInOutDetailNew.raq&StartMonth="+getElementValue("StartMonth")+"&EndMonth="+getElementValue("EndMonth")+"&UseLocDR="+getElementValue("UseLocDR")+"&EquipDR="+getElementValue("EquipDR")+"&Equip="+getElementValue("Equip");
	//alert(val)
	var url="dhceq.ba.inoutdetailnew.csp?"+val;
	window.location.href=url;
}
function refreshReport()
{
	var ColTColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902001");
	var DataColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902002");
	var SumColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902003");
	var Colorstr="&ColTColor="+ColTColor+"&DataColor="+DataColor+"&SumColor="+SumColor;
	var ReportFileName=jQuery("#ReportFileName").val();
	var PrintFlag=getElementValue("PrintFlag");
	var PrintStr="";
	var lnk="&StartMonth="+getElementValue("StartMonth")+"&EndMonth="+getElementValue("EndMonth")+"&UseLocDR="+getElementValue("UseLocDR")+"&EquipDR="+getElementValue("EquipDR")+"&Equip="+getElementValue("Equip");
	if (PrintFlag==2) PrintStr="&PrintFlag=1"
	//alert("lnk="+lnk)
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+PrintStr+Colorstr;
}