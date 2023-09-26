
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&vPlanDR="+getElementValue("PlanDR");
	lnk=lnk+"&vSourceTypeDR="+getElementValue("SourceTypeDR");
	lnk=lnk+"&vEquipDR="+getElementValue("EquipDR");
	lnk=lnk+"&vEquipNo=";
	lnk=lnk+"&vEquipName=";
	lnk=lnk+"&vModelDR="+getElementValue("ModelDR");
	lnk=lnk+"&vMaintUserDR="+getElementValue("MaintUserDR");
	lnk=lnk+"&vMaintLocDR="+getElementValue("MaintLocDR");
	lnk=lnk+"&vMaintTypeDR="+getElementValue("MaintTypeDR");
	lnk=lnk+"&vStartDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&vEndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&vStatusDR="+getElementValue("StatusDR");
	lnk=lnk+"&vFromYear="+jQuery("#FromYear").val();
	lnk=lnk+"&vToYear="+jQuery("#ToYear").val();
	lnk=lnk+"&vUseLocDR="+getElementValue("UseLocDR");
	lnk=lnk+"&vMeasureFlag="+getElementValue("MeasureFlagDR");
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="vPlan=Plan^vMaintLoc=MaintLoc^vUseLoc=UseLoc";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}
