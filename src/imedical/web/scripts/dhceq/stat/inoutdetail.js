function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&EquipID="+GlobalObj.BenifitEquipDR;    //modified by czf 378269
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&StartDate="+GetJQueryDate('#SMonthStr');
	lnk=lnk+"&EndDate="+GetJQueryDate('#EMonthStr');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="BenifitEquip^UseLoc";
	var Elements2="EquipName=BenifitEquip";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}